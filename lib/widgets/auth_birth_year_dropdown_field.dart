// lib/widgets/auth_birth_year_dropdown_field.dart
import 'package:flutter/material.dart';

class AuthBirthYearDropdownField extends StatelessWidget {
  final String? selectedBirthYear; // 현재 선택된 탄생 연도
  final ValueChanged<String?> onChanged; // 값이 변경될 때 호출될 콜백 함수
  final int minYear;
  final int maxYear;
  const AuthBirthYearDropdownField({
    super.key,
    required this.selectedBirthYear,
    required this.onChanged,
    required this.minYear, // ✨ 필수 매개변수로 추가
    required this.maxYear, // ✨ 필수 매개변수로 추가
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