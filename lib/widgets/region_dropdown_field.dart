import 'package:flutter/material.dart';

class RegionDropdownField extends StatelessWidget {
  final String? selectedRegion;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final List<Map<String, String>> regions; // 외부에서 파싱된 지역 목록을 받도록 변경

  const RegionDropdownField({
    super.key,
    required this.selectedRegion,
    required this.onChanged,
    required this.regions, // 필수 인자로 추가
    this.labelText = '지역',
  });

  @override
  Widget build(BuildContext context) {
    // 지역 목록을 DropdownMenuItem으로 변환
    final List<DropdownMenuItem<String>> regionItems = [
      const DropdownMenuItem(value: null, child: Text('지역 선택')), // 기본 '선택' 옵션
      ...regions.map((region) {
        return DropdownMenuItem(
          value: region['value'],
          child: Text(region['label']!),
        );
      }),
    ];

    return DropdownButtonFormField<String>(
      value: selectedRegion,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.location_on),
      ),
      items: regionItems,
      onChanged: onChanged,
    );
  }
}