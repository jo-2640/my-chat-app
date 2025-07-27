// lib/widgets/age_group_dropdown_field.dart

import 'package:flutter/material.dart';
import 'package:fist_app/utils/age_group_utils.dart';

class AgeGroupDropdownField extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String type; // 'min' 또는 'max'
  final String labelText;
  final List<AgeGroup> ageGroupsToDisplay;

  const AgeGroupDropdownField({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.type,
    required this.ageGroupsToDisplay,
    this.labelText = '연령대',

  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        prefixIcon: const Icon(Icons.group),
      ),
      items: AgeGroupUtils.buildAgeGroupDropdownItems(ageGroupsToDisplay,type, includeDefault: true),
      onChanged: onChanged,
    );
  }
}