import 'package:flutter/material.dart';

class AuthNicknameInputField extends StatelessWidget{
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isLoginMode;
  const AuthNicknameInputField({
    super.key,
    required this.controller,
    this.validator,
    required this.isLoginMode,
  });
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isLoginMode, // isLoginMode가 false일 때만 보이도록
      maintainState: false,
      maintainAnimation: false,
      maintainSize: false,
      child: TextFormField(
        key: const ValueKey('nickname'),
        controller: controller,
        decoration: const InputDecoration(labelText: '닉네임'),
        validator: validator,
      ),
    );
  }
}
