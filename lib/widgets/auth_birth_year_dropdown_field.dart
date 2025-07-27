// lib/widgets/auth_birth_year_dropdown_field.dart
import 'package:flutter/material.dart';

class AuthBirthYearDropdownField extends StatelessWidget {
  final String? selectedBirthYear;
  final ValueChanged<String?> onChanged;
  final int minYear;
  final int maxYear;
  const AuthBirthYearDropdownField({
    super.key,
    required this.selectedBirthYear,
    required this.onChanged,
    required this.minYear,
    required this.maxYear,
  });

  @override
  Widget build(BuildContext context) {

    // 드롭다운 메뉴 아이템 생성 (현재 연도부터 1900년까지 역순)
    final List<DropdownMenuItem<String>> yearItems = List.generate(
      maxYear - minYear  + 1,
          (index) => (minYear + index).toString(),
    ).reversed.map((year) {
      return DropdownMenuItem(value: year, child: Text(year));
    }).toList();

    return DropdownButtonFormField<String>(
      value: selectedBirthYear,
      decoration: InputDecoration(
        labelText: '탄생 연도',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      items: yearItems, // 위에서 생성한 연도 아이템 리스트 사용
      onChanged: onChanged, // 부모에서 받은 콜백 함수 연결
    );
  }
}