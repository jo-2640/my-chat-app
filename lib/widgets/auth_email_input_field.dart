import 'package:flutter/material.dart';

class AuthEmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator; // validator를 외부에서 받을 수 있도록 추가

  const AuthEmailInputField({
    super.key,
    required this.controller,
    this.validator, // validator는 필수가 아닐 수 있으므로 nullable
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일',
        hintText: 'user@example.com',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.email),
      ),
      validator: validator, // 외부에서 받은 validator 함수 사용
    );
  }
}