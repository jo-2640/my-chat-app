// lib/services/config_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fist_app/utils/app_logger.dart';
import 'package:fist_app/constants/app_constants.dart';

class ConfigService {
  final url = Uri.parse('$baseUrl/api/getBirthYearRange');

  // 서버에서 허용된 최소/최대 탄생 연도 범위를 가져옵니다.
  // 성공 시 Map<String, int> 형태의 'minYear': int, 'maxYear': int를 반환하고,
  // 실패 시에는 null을 반환합니다.
  static Future<Map<String, int>?> getBirthYearRange() async {
    try {
      final url = Uri.parse('$baseUrl/api/getBirthYearRange');
      appLogger.d('ConfigService: API 호출 URL 준비: $url');

      final response = await http.get(url);

      appLogger.d('ConfigService: API 응답 상태 코드: ${response.statusCode}');
      appLogger.d('ConfigService: API 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // ⭐ 여기서는 서버에서 null이 올 가능성을 대비하여 null-aware 캐스팅을 사용합니다.
          //    Node.js 서버에서 항상 유효한 숫자를 보내도록 고쳤다면 굳이 필요 없지만,
          //    클라이언트의 견고성을 위해 추가해 두는 것이 좋습니다.
          final int? minYear = data['minYear'] as int?;
          final int? maxYear = data['maxYear'] as int?;

          if (minYear != null && maxYear != null) {
            appLogger.i('탄생 연도 범위 서버에서 로드 성공: $minYear - $maxYear');
            return {'minYear': minYear, 'maxYear': maxYear};
          } else {
            appLogger.e('서버에서 받은 minYear 또는 maxYear가 null입니다.');
            return null; // 데이터가 완전하지 않으면 null 반환
          }
        } else {
          appLogger.e('서버 응답 성공이 false입니다: ${data['message']}');
          return null;
        }
      } else {
        appLogger.e('탄생 연도 범위 API 호출 실패: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e, s) {
      appLogger.e('탄생 연도 범위 로드 중 네트워크/파싱 오류 발생:', error: e, stackTrace: s);
      return null;
    }
  }
  static List<Map<String, String>> getRegions() {
    final String regionsString = regions ;
    if (regionsString.isEmpty) {
      appLogger.w('ConfigService: REGIONS 환경 변수가 설정되지 않았거나 비어 있습니다.');
      return [];
    }

    final List<Map<String, String>> parsedRegions = [];
    final List<String> regionPairs = regionsString.split(',');

    for (var pair in regionPairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        parsedRegions.add({
          'value': parts[0].trim(),
          'label': parts[1].trim(),
        });
      } else {
        appLogger.w('ConfigService: 유효하지 않은 REGIONS 항목 발견: $pair');
      }
    }
    appLogger.i('ConfigService: 지역 목록 로드 ff완료: $parsedRegions');
    return parsedRegions;
  }
}