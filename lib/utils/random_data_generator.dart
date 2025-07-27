// lib/utils/random_data_generator.dart
import 'dart:math';

// 이메일 주소의 로컬 부분에 사용할 문자열 (숫자와 소문자)
const String _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
final Random _rnd = Random();

String generateRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

String generateRandomEmail() {
  final String username = generateRandomString(8);
  final List<String> domains = ['example.com', 'test.org', 'mail.net', 'domain.co.kr'];
  final String domain = domains[_rnd.nextInt(domains.length)];
  return '$username@$domain';
}

T getRandomElement<T>(List<T> list) {
  return list[_rnd.nextInt(list.length)];
}

// AgeGroupUtils.detailedAgeGroupsFlutter와 같은 방식으로 연령대 목록을 가져옵니다.
// 이 부분은 기존 앱의 AgeGroupUtils 파일을 참조합니다.
// 예를 들어, lib/utils/age_group_utils.dart 에 다음과 같이 정의되어 있다고 가정합니다.
/*
class AgeGroup {
  final String value;
  final String label;
  AgeGroup(this.value, this.label);
}

class AgeGroupUtils {
  static final List<AgeGroup> detailedAgeGroupsFlutter = [
    AgeGroup('10-under', '~10세'),
    AgeGroup('10s', '10대'),
    AgeGroup('20s', '20대'),
    AgeGroup('30s', '30대'),
    AgeGroup('40s', '40대'),
    AgeGroup('50s', '50대'),
    AgeGroup('60-plus', '60대 이상'),
  ];
}
*/

// 실제 프로젝트에 맞게 `AgeGroupUtils.detailedAgeGroupsFlutter`를 임포트하고 사용하세요.