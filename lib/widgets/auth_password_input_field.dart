import 'package:flutter/material.dart';

class AuthPasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool initialObscureText;
  final String? Function(String?)? validator;

  const AuthPasswordInputField({
    super.key,
    required this.controller,
    required this.initialObscureText,
    this.validator,
  });

  @override
  State<AuthPasswordInputField> createState() => _AuthPasswordInputFieldState();
}

class _AuthPasswordInputFieldState extends State<AuthPasswordInputField> {
  late bool _obscureText; // 내부 상태로 관리

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText, // 내부 상태 사용
      decoration: InputDecoration(
        labelText: '비밀번호 (6자 이상)',
        hintText: '••••••••',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleVisibility, // 내부에서 상태 변경
        ),
      ),
      validator: widget.validator,
    );
  }
}