// lib/widgets/auth_submit_button.dart
import 'package:flutter/material.dart';

// StatelessWidget을 StatefulWidget으로 변경합니다.
class AuthSubmitButton extends StatefulWidget {
  // 이제 isLoading을 외부에서 받지 않고 내부에서 관리합니다.
  final bool isLoginMode;
  // onSubmit 함수는 Future<void>를 반환하도록 변경하여
  // 버튼 내부에서 이 함수의 완료를 기다릴 수 있도록 합니다.
  final Future<void> Function() onSubmit;

  const AuthSubmitButton({
    super.key,
    required this.isLoginMode,
    required this.onSubmit,
  });

  @override
  State<AuthSubmitButton> createState() => _AuthSubmitButtonState();
}

class _AuthSubmitButtonState extends State<AuthSubmitButton> {
  bool _isLoading = false; // <<< 버튼 자체의 로딩 상태를 관리하는 내부 변수

  // 버튼이 눌렸을 때 실행될 로직
  Future<void> _handleSubmit() async {
    if (_isLoading) return; // 이미 로딩 중이면 중복 클릭 방지

    setState(() {
      _isLoading = true; // 로딩 시작
    });

    try {
      // 외부에서 전달받은 onSubmit 함수를 실행하고 완료될 때까지 기다립니다.
      await widget.onSubmit();
    } catch (e) {
      // onSubmit 함수 내에서 발생한 예외 처리 (예: 네트워크 오류, 인증 실패 등)
      // 필요하다면 여기서 추가적인 오류 메시지를 사용자에게 보여줄 수 있습니다.
      // appLogger.e('AuthSubmitButton: onSubmit 중 오류 발생', error: e); // appLogger가 있다면 사용
    } finally {
      // 작업이 완료되면 로딩 상태를 해제합니다.
      // 위젯이 여전히 마운트되어 있는지 확인하는 것이 안전합니다.
      if (mounted) {
        setState(() {
          _isLoading = false; // 로딩 종료
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // 내부 _isLoading 상태에 따라 버튼 활성화/비활성화 및 로딩 인디케이터 표시
      onPressed: _isLoading ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: _isLoading // 로딩 중이면 CircularProgressIndicator 표시
          ? const CircularProgressIndicator(color: Colors.white)
          : Text( // 로딩 중이 아니면 텍스트 표시
        widget.isLoginMode ? '로그인' : '회원가입',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
