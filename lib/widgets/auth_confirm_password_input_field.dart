import 'package:flutter/material.dart';

class AuthConfirmPasswordInputField extends StatefulWidget{
    final TextEditingController controller;
    final TextEditingController mainPasswordController;
    final bool initialObscureText;

    const AuthConfirmPasswordInputField({
      super.key,
      required this.controller,
      required this.mainPasswordController,
      required this.initialObscureText,
    });

    @override
    State<AuthConfirmPasswordInputField>  createState() => _AuthConfirmPassWordInputFieldState();
}

class _AuthConfirmPassWordInputFieldState extends State<AuthConfirmPasswordInputField>{
  late bool _obscureConfirmPassword;

  @override
  void initState(){
      super.initState();
      _obscureConfirmPassword =widget.initialObscureText;
  }

  void _toggleVisibility(){
      setState(() {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      });
  }

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: '비밀번호 확인',
        hintText: '********',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: _toggleVisibility,
        ),
      ),
    validator: (value){
        if(value == null || value.isEmpty){
          return '비밀번호 확인을 입력해주세요.' ;
        }
        if(value != widget.mainPasswordController.text) {
          return '비밀번호가 일치하지 않습니다.';
        }
        return null;
      },
    );
  }
}