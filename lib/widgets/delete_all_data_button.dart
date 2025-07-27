// lib/widgets/delete_all_data_button.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fist_app/services/auth_service.dart';
import 'package:fist_app/utils/app_logger.dart';
import 'package:fist_app/services/config_service.dart'; // ConfigService 임포트

class DeleteAllDataButton extends StatefulWidget {
  const DeleteAllDataButton({super.key});

  @override
  State<DeleteAllDataButton> createState() => _DeleteAllDataButtonState();
}

class _DeleteAllDataButtonState extends State<DeleteAllDataButton> {
  bool _isDeleting = false;
  String? _deleteMessage;

  Future<void> _handleDeleteAllDataLogic() async {
    setState(() {
      _isDeleting = true;
      _deleteMessage = null;
    });

    try {
      // ConfigService를 통해 BASE_URL을 가져옵니다.
      // dotenv.env['BASE_URL']에 직접 접근하는 대신 ConfigService를 사용하는 것이 좋습니다.
      final String? baseUrl = ConfigService.getBaseUrl(); // ✨ ConfigService에서 baseUrl 가져오는 메서드 호출
      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('BASE_URL이 설정되지 않았습니다. .env 파일을 확인해주세요.');
      }

      final url = Uri.parse('$baseUrl/api/delete-all-data');
      appLogger.d('클라이언트에서 데이터 삭제 API 호출: $url');

      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.auth.currentUser?.uid}', // 사용자 UID를 토큰으로 사용
      });

      if (response.statusCode == 200) {
        setState(() {
          _deleteMessage = '모든 사용자 데이터가 성공적으로 삭제되었습니다.';
        });
        appLogger.i('모든 사용자 데이터 삭제 성공');
        // 선택 사항: 삭제 후 로그아웃 처리
        await AuthService.auth.signOut();
      } else {
        setState(() {
          _deleteMessage = '데이터 삭제 실패: ${response.statusCode} - ${response.body}';
        });
        appLogger.e('데이터 삭제 실패: ${response.statusCode} - ${response.body}');
      }
    } catch (e, s) {
      setState(() {
        _deleteMessage = '클라이언트에서 데이터 삭제 API 호출 오류: $e';
      });
      appLogger.e('클라이언트에서 데이터 삭제 API 호출 오류:', error: e, stackTrace: s);
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  // 사용자에게 확인 메시지를 보여주는 다이얼로그
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('모든 데이터 삭제'),
          content: const Text('정말로 모든 사용자 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _handleDeleteAllDataLogic(); // 데이터 삭제 로직 실행
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _isDeleting ? null : _showDeleteConfirmationDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(250, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: _isDeleting
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('모든 데이터 삭제 (개발용)'),
        ),
        if (_deleteMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _deleteMessage!,
              style: TextStyle(
                color: _deleteMessage!.contains('성공') ? Colors.green : Colors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}