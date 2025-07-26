// lib/utils/dialog_utils.dart
import 'package:flutter/material.dart';

class DialogUtils {
  /// 단일 확인 다이얼로그를 표시하고 결과를 반환합니다.
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmButtonText,
    Color confirmButtonColor = Colors.blue, // 기본값 설정
    String cancelButtonText = '취소',
  }) async {
    // 다이얼로그를 닫으면 null이 반환될 수 있으므로 ?? false 사용
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: confirmButtonColor)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmButtonText, style: TextStyle(color: confirmButtonColor)),
          ),
        ],
      ),
    );
    return result ?? false; // null이면 false 반환
  }

  /// 모든 데이터 삭제를 위한 이중 확인 다이얼로그를 표시합니다.
  /// 두 번 모두 확인해야 true를 반환합니다.
  static Future<bool> showDeleteAllDataConfirmation(BuildContext context) async {
    // 첫 번째 확인
    final bool confirm1 = await showConfirmationDialog(
      context: context,
      title: '경고',
      content: '정말로 모든 사용자 계정과 Firestore 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다!',
      confirmButtonText: '삭제',
      confirmButtonColor: Colors.red,
    );

    // 첫 번째 다이얼로그 이후 위젯이 언마운트되었는지 확인 (비동기 작업의 필수 안전장치)
    if (!context.mounted) return false;

    // 첫 번째 확인이 false라면 바로 종료
    if (!confirm1) return false;

    // 두 번째 최종 확인
    final bool confirm2 = await showConfirmationDialog(
      context: context,
      title: '최종 확인',
      content: '모든 데이터가 영구적으로 삭제됩니다. 계속하시겠습니까?',
      confirmButtonText: '삭제',
      confirmButtonColor: Colors.red,
    );

    // 두 번째 다이얼로그 이후 위젯이 언마운트되었는지 확인
    if (!context.mounted) return false;

    return confirm2; // 두 번째 확인 결과 반환
  }
}