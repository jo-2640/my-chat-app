// lib/widgets/delete_all_data_button.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP 요청을 위해 필요
import 'dart:convert'; // JSON 파싱을 위해 필요
import 'package:fist_app/services/auth_service.dart'; // AuthService 사용을 위해 필요
import 'package:fist_app/utils/app_logger.dart'; // appLogger 사용을 위해 필요
import 'package:fist_app/utils/utils.dart'; // showToast 사용을 위해 필요
import 'package:fist_app/utils/dialog_utils.dart'; // 새로 만든 DialogUtils 사용
import 'package:fist_app/constants/app_constants.dart';
class DeleteAllDataButton extends StatefulWidget {
  // 이제 isLoading이나 onDeleteAllData를 외부에서 받을 필요가 없습니다.
  // 이 위젯이 모든 것을 자체적으로 관리합니다.
  const DeleteAllDataButton({super.key});

  @override
  State<DeleteAllDataButton> createState() => _DeleteAllDataButtonState();
}

class _DeleteAllDataButtonState extends State<DeleteAllDataButton> {
  bool _isLoading = false; // 버튼 자체의 로딩 상태를 관리합니다.

  // _handleDeleteAllData 로직 전체를 이 위젯의 상태 안으로 이동
  Future<void> _handleDeleteAllDataLogic() async {
    // _isLoading 상태를 true로 설정하여 버튼을 비활성화하고 로딩 상태를 표시
    setState(() {
      _isLoading = true;
    });

    try {
      // 다이얼로그 유틸리티를 사용하여 이중 확인 과정을 처리
      // 이 위젯의 context를 사용합니다.
      final bool confirmedToDelete = await DialogUtils.showDeleteAllDataConfirmation(context);

      // 다이얼로그 확인 도중 위젯이 언마운트되었는지 확인
      if (!mounted) return;

      // 사용자가 삭제를 최종 확인하지 않았다면 로딩 상태를 해제하고 종료
      if (!confirmedToDelete) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 여기까지 왔다면, 사용자가 최종적으로 삭제를 확인한 것입니다.
      showToast(context, '모든 데이터 삭제 요청 중...', 'info'); // context 사용

      final response = await http.post(
        Uri.parse('$baseUrl/delete-all-data'),
        headers: {'Content-Type': 'application/json'},
      );

      // 네트워크 요청 후 위젯이 언마운트되었는지 확인
      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        showToast(context, data['message'], 'success'); // context 사용
        await AuthService.handleLogout(context); // context 사용
      } else {
        final data = jsonDecode(response.body);
        showToast(context, data['message'] ?? '데이터 삭제 실패', 'error'); // context 사용
      }
    } catch (e, s) {
      appLogger.e("클라이언트에서 데이터 삭제 API 호출 오류:", error: e, stackTrace: s); // appLogger 사용
      if (mounted) {
        showToast(context, '데이터 삭제 중 네트워크 오류 발생', 'error'); // context 사용
      }
    } finally {
      // 모든 작업 완료 후 (성공/실패/에러와 관계없이) 로딩 상태 해제
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox( // 기존 AuthScreen에서 너비 250을 줬으므로 여기에 SizedBox 추가
      width: 250,
      child: ElevatedButton(
        // 이 위젯의 내부 로딩 상태와 로직을 연결
        onPressed: _isLoading ? null : _handleDeleteAllDataLogic,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700, // 위험한 작업임을 나타내는 빨간색 배경
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Text(
          '모든 데이터 삭제 (위험!)', // 고정 텍스트
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}