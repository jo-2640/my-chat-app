// lib/widgets/auth_mode_toggle_button.dart
import 'package:flutter/material.dart';

class AuthModeToggleButton extends StatelessWidget {
  final bool isLoading;
  final bool isLoginMode;
  final VoidCallback onToggleMode; // 모드 전환 함수

  const AuthModeToggleButton({
    super.key,
    required this.isLoading,
    required this.isLoginMode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onToggleMode, // isLoading에 따라 비활성화 또는 onToggleMode 실행
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200], // 배경색
        foregroundColor: Theme.of(context).primaryColor, // 글씨색
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        isLoginMode ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인', // isLoginMode에 따라 텍스트 변경
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}