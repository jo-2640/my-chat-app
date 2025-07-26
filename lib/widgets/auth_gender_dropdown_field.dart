import 'package:flutter/material.dart';

class  AuthGenderDropdownField extends StatelessWidget{
    final String? selectedGender;
    final ValueChanged<String?> onChanged;

    const AuthGenderDropdownField({
      super.key,
      required this.selectedGender,
      required this.onChanged
    });

    @override
    Widget build(BuildContext context){
      return DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: InputDecoration(
            labelText: '성별',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            prefixIcon: const Icon(Icons.wc),
          ),
        items: const [
          DropdownMenuItem(value: 'male' ,child: Text('남성')),
          DropdownMenuItem(value: 'female', child: Text('여성')),
        ],
        onChanged: onChanged,
      );
    }
}