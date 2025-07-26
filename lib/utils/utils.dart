// lib/utils/utils.dart
import 'package:flutter/material.dart'; // BuildContext, ScaffoldMessenger, SnackBar 등을 위해
import 'package:fist_app/utils/app_logger.dart'; // 로깅을 위해

/// 토스트 메시지를 화면에 표시합니다.
/// [message] 표시할 메시지
/// [type] 'info', 'success', 'error' 중 하나 (색상 및 아이콘에 영향)
void showToast(BuildContext context, String message, [String type = 'info']) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case 's':  //success
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case 'e':  //error
      backgroundColor = Colors.red;
      icon = Icons.error;
      break;
    case 'i':
    default: //info
      backgroundColor = Colors.blueGrey;
      icon = Icons.info;
      break;
  }

  // 기존 스낵바를 숨기고 새로운 스낵바 표시
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3), // 3초 후 자동 사라짐
      behavior: SnackBarBehavior.floating, // 플로팅 스타일 (상단에도 띄울 수 있음)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(10), // 모서리에 여백 주기
    ),
  );
  appLogger.i('토스트 메시지 표시: [$type] $message');
}

// 모든 나이대 그룹 정보
// JS의 detailedAgeGroups 상수를 Dart의 List<Map<String, dynamic>>으로 변환
final List<Map<String, dynamic>> detailedAgeGroups = [
  {"value": "10-under", "baseLabel": "10대", "label": "10대 이하", "min": 0, "max": 19},
  {"value": "20-early", "baseLabel": "20대", "label": "20대 초반 (20-23세)", "min": 20, "max": 23},
  {"value": "20-mid", "baseLabel": "20대", "label": "20대 중반 (24-27세)", "min": 24, "max": 27},
  {"value": "20-late", "baseLabel": "20대", "label": "20대 후반 (28-29세)", "min": 28, "max": 29},
  {"value": "30-early", "baseLabel": "30대", "label": "30대 초반 (30-33세)", "min": 30, "max": 33},
  {"value": "30-mid", "baseLabel": "30대", "label": "30대 중반 (34-37세)", "min": 34, "max": 37},
  {"value": "30-late", "baseLabel": "30대", "label": "30대 후반 (38-39세)", "min": 38, "max": 39},
  {"value": "40-early", "baseLabel": "40대", "label": "40대 초반 (40-43세)", "min": 40, "max": 43},
  {"value": "40-mid", "baseLabel": "40대", "label": "40대 중반 (44-47세)", "min": 44, "max": 47},
  {"value": "40-late", "baseLabel": "40대", "label": "40대 후반 (48-49세)", "min": 48, "max": 49},
  {"value": "50-early", "baseLabel": "50대", "label": "50대 초반 (50-53세)", "min": 50, "max": 53},
  {"value": "50-mid", "baseLabel": "50대", "label": "50대 중반 (54-57세)", "min": 54, "max": 57},
  {"value": "50-late", "baseLabel": "50대", "label": "50대 후반 (58-59세)", "min": 58, "max": 59},
  {"value": "60-plus", "baseLabel": "60대", "label": "60대 이상", "min": 60, "max": 150}
];

/// 출생 연도를 기반으로 사용자의 연령대 레이블을 반환합니다.
/// 이 함수는 주로 프로필 표시 등에서 사용될 때, 저장된 'value'에 해당하는 상세 레이블을 반환합니다.
String getAgeGroupLabel(String ageGroupValue) {
  final group = detailedAgeGroups.firstWhere(
        (g) => g['value'] == ageGroupValue,
    orElse: () => {"label": "나이 정보 없음"}, // 찾지 못할 경우 기본값 반환
  );
  return group['label'] as String;
}

/// 성별 값을 한국어 레이블로 변환합니다.
String getGenderLabel(String gender) {
  if (gender == 'male') return '남성';
  if (gender == 'female') return '여성';
  return '선택 안함';
}

/// 지역 값을 한국어 레이블로 변환합니다.
String getRegionLabel(String region) {
  switch (region) {
    case 'seoul': return '서울';
    case 'gyeonggi': return '경기';
    case 'incheon': return '인천';
    case 'busan': return '부산';
    case 'daegu': return '대구';
    case 'gwangju': return '광주';
    case 'daejeon': return '대전';
    case 'ulsan': return '울산';
    case 'sejong': return '세종';
    case 'gangwon': return '강원';
    case 'chungbuk': return '충북';
    case 'chungnam': return '충남'; // JS 코드에 return 누락 수정
    case 'jeonbuk': return '전북';
    case 'jeonnam': return '전남';
    case 'gyeongbuk': return '경북';
    case 'gyeongnam': return '경남';
    case 'jeju': return '제주';
    default: return '지역 정보 없음';
  }
}

/// 성별에 따른 기본 프로필 이미지 경로를 반환합니다.
/// 이 경로는 Flutter의 assets 경로에 맞게 조정해야 합니다.
String getDefaultProfileImage(String? gender) { // gender가 null일 수 있도록 String?
  if (gender == 'male') {
    return 'assets/img/default_profile_male.png';
  } else if (gender == 'female') {
    return 'assets/img/default_profile_female.png';
  } else {
    return 'assets/img/default_profile_guest.png';
  }
}

/// 드롭다운 옵션 텍스트 생성을 위한 헬퍼 함수
/// 'min' 타입일 때는 '이상'을, 'max' 타입일 때는 '이하'를 붙입니다.
String getAgeGroupOptionLabel(Map<String, dynamic> group, String type) {
  // '10대 이하'와 '60대 이상'은 특별 케이스로 그대로 반환
  if (group['value'] == "10-under" || group['value'] == "60-plus") {
    return group['label'] as String;
  }

  // 그 외 연령대는 상세 레이블에 '이상' 또는 '이하'를 붙여 반환
  return '${group['label']}${type == 'min' ? ' 이상' : ' 이하'}';
}