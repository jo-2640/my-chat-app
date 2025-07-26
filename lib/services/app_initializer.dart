// lib/services/app_initializer.dart
import 'package:flutter/widgets.dart'; // WidgetsFlutterBinding.ensureInitialized() 사용을 위해 필요
import 'package:flutter_dotenv/flutter_dotenv.dart'; // .env 로드를 위해 필요
import 'package:fist_app/constants/app_constants.dart'; // 전역 상수들을 임포트

/// 앱의 모든 초기화 작업을 담당하는 서비스 클래스입니다.
class AppInitializer {
  /// 앱 시작 시 호출되어야 하는 초기화 메소드입니다.
  /// 이 메소드 내에서 전역 상수들을 초기화합니다.
  static Future<void> initialize() async {
    // Flutter 위젯 바인딩이 초기화되었는지 확인합니다.
    // runApp() 호출 전에 플러터 엔진과 상호작용하는 모든 코드에 필요합니다.
    WidgetsFlutterBinding.ensureInitialized();

    // `.env` 환경 변수 파일 로드 (이 작업이 완료되어야 `dotenv.env` 맵에 접근 가능합니다).
    await dotenv.load(fileName: ".env");

    // `.env`에서 읽어온 BASE_URL 값을 전역 상수 `BASE_URL`에 할당합니다.
    baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
    regions = dotenv.env['REGIONS'] ?? '지역이 정상적으로 로드되지않았습니다';
    // 여기에 다른 초기화 로직을 추가할 수 있습니다:
    // - 로깅 시스템 초기화
    // - 데이터베이스 초기화
    // - Firebase 초기화 등
    // appLogger.i('앱 초기화 완료');
  }
}