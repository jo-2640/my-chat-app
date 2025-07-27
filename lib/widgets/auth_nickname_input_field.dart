import 'package:flutter/material.dart';

class AuthNicknameInputField extends StatelessWidget{
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const AuthNicknameInputField({
    super.key,
    required this.controller,
    this.validator,
 });
  @override
  Widget build(BuildContext context) {
    return Visibility(
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
