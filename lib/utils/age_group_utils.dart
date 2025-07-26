//utils/age_group_utils.dart

import 'package:flutter/material.dart';
class AgeGroup {
  final String value;
  final String label;

  AgeGroup({required this.value, required this.label});
}

// detailedAgeGroupsFlutter 리스트도 이 파일에 함께 정의하거나,
// 별도의 데이터 파일에서 가져와야 합니다.
final List<AgeGroup> detailedAgeGroupsFlutter = [
  AgeGroup(value: "10-under", label: "10대 이하"),
  AgeGroup(value: "20", label: "20대"),
  AgeGroup(value: "30", label: "30대"),
  AgeGroup(value: "40", label: "40대"),
  AgeGroup(value: "50", label: "50대"),
  AgeGroup(value: "60-plus", label: "60대 이상"),
];


class AgeGroupUtils {
  // JavaScript의 getAgeGroupOptionLabel 함수와 동일한 로직 구현
  static String getAgeGroupOptionLabel(AgeGroup group, String type) {
    // '10대 이하'와 '60대 이상'은 특별 케이스로 그대로 반환
    if (group.value == "10-under" || group.value == "60-plus") {
      return group.label;
    }

    // 그 외 연령대는 상세 레이블에 '이상' 또는 '이하'를 붙여 반환
    return '${group.label}${type == 'min' ? ' 이상' : ' 이하'}';
  }

  // 드롭다운 옵션 생성 함수 업데이트
  static List<DropdownMenuItem<String>> buildAgeGroupDropdownItems(String type, {bool includeDefault = false}) {
    List<DropdownMenuItem<String>> items = [];

    if (includeDefault) {
      items.add(const DropdownMenuItem(value: null, child: Text('선택')));
    }

    // `detailedAgeGroupsFlutter`를 사용하여 옵션 생성
    for (var group in detailedAgeGroupsFlutter) {
      items.add(
        DropdownMenuItem(
          value: group.value,
          child: Text(getAgeGroupOptionLabel(group, type)), // 동적 레이블 사용
        ),
      );
    }
    return items;
  }

  // 출생 연도 목록을 생성하고 기본값을 설정하는 함수
  // 이 함수는 UI 상태를 직접 변경하지 않고 연도 목록과 기본값을 반환하도록 수정하는 것이 좋습니다.
  static String getDefaultBirthYear() {
    final currentYear = DateTime.now().year;
    return (currentYear - 20).toString(); // 기본값 설정
  }
}