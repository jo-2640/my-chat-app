//lib/utils/age_groups.dart;
import 'package:flutter/material.dart';

class AgeGroup {
  final String value; // 예: "20-early", "20-mid", "20-late"
  final String label; // 예: "20대 초반", "20대 중반", "20대 후반"
  final int minYearOffset; // 현재 연도에서 이 값을 빼서 시작 연령을 대략적으로 계산 (선택 사항)
  final int maxYearOffset; // 현재 연도에서 이 값을 빼서 끝 연령을 대략적으로 계산 (선택 사항)


  AgeGroup({
    required this.value,
    required this.label,
    this.minYearOffset = 0, // 기본값 설정
    this.maxYearOffset = 0, // 기본값 설정
  });
}

class AgeGroupUtils {
  static final List<AgeGroup> detailedAgeGroupsFlutter = [
    // 특별 케이스: 10대 이하
    AgeGroup(value: "10-under", label: "10대 이하"),

    // 20대 세분화
    AgeGroup(value: "20-early", label: "20대 초반", minYearOffset: 20, maxYearOffset: 23),
    AgeGroup(value: "20-mid", label: "20대 중반", minYearOffset: 24, maxYearOffset: 26),
    AgeGroup(value: "20-late", label: "20대 후반", minYearOffset: 27, maxYearOffset: 29),

    // 30대 세분화
    AgeGroup(value: "30-early", label: "30대 초반", minYearOffset: 30, maxYearOffset: 33),
    AgeGroup(value: "30-mid", label: "30대 중반", minYearOffset: 34, maxYearOffset: 36),
    AgeGroup(value: "30-late", label: "30대 후반", minYearOffset: 37, maxYearOffset: 39),

    // 40대 세분화
    AgeGroup(value: "40-early", label: "40대 초반", minYearOffset: 40, maxYearOffset: 43),
    AgeGroup(value: "40-mid", label: "40대 중반", minYearOffset: 44, maxYearOffset: 46),
    AgeGroup(value: "40-late", label: "40대 후반", minYearOffset: 47, maxYearOffset: 49),

    // 50대 세분화
    AgeGroup(value: "50-early", label: "50대 초반", minYearOffset: 50, maxYearOffset: 53),
    AgeGroup(value: "50-mid", label: "50대 중반", minYearOffset: 54, maxYearOffset: 56),
    AgeGroup(value: "50-late", label: "50대 후반", minYearOffset: 57, maxYearOffset: 59),

    // 특별 케이스: 60대 이상
    AgeGroup(value: "60-plus", label: "60대 이상"),
  ];

  // getAgeGroupOptionLabel 함수를 업데이트하여 '이상'/'이하'를 붙입니다.
  static String getAgeGroupOptionLabel(AgeGroup group, String type) {
    // '10대 이하'와 '60대 이상'은 특별 케이스로 그대로 반환합니다.
    if (group.value == "10-under" || group.value == "60-plus") {
      return group.label;
    }

    // 그 외 연령대는 type에 따라 '이상' 또는 '이하'를 붙여 반환합니다.
    return '${group.label}${type == 'min' ? ' 이상' : ' 이하'}';
  }

  // 드롭다운 옵션 생성 함수 업데이트 (여기서는 변경 없음, 위에서 label 처리 방식 변경)
  static List<DropdownMenuItem<String>> buildAgeGroupDropdownItems(List<AgeGroup> ageGroupsToDisplay, String type, {bool includeDefault = false}) {
    List<DropdownMenuItem<String>> items = [];

    if (includeDefault) {
      items.add(const DropdownMenuItem(value: null, child: Text('선택')));
    }

    for (var group in ageGroupsToDisplay) { // 전달받은 리스트를 사용하여 옵션 생성
      items.add(
        DropdownMenuItem(
          value: group.value,
          child: Text(getAgeGroupOptionLabel(group, type)), // getAgeGroupOptionLabel을 사용하여 동적 레이블 생성
        ),
      );
    }
    return items;
  }

  // 헬퍼 함수: AgeGroupUtils.detailedAgeGroupsFlutter 리스트에서 AgeGroup 객체를 찾는 함수
  static AgeGroup? getAgeGroupFromValue(String value) {
    try {
      return detailedAgeGroupsFlutter.firstWhere((group) => group.value == value);
    } catch (e) {
      return null; // 해당하는 AgeGroup이 없을 경우
    }
  }

  // 헬퍼 함수: AgeGroup의 순서 인덱스를 반환 (최소/최대 비교용)
  // '10-under'를 0으로, '20-early'를 1로... '60-plus'를 마지막 인덱스로
  static int getAgeGroupIndex(String value) {
    return detailedAgeGroupsFlutter.indexWhere((group) => group.value == value);
  }
}
