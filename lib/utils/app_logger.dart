// lib/utils/app_logger.dart
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart'; // kDebugMode를 위해 import

// 앱 전체에서 사용할 Logger 인스턴스를 정의합니다.
// 이 로거는 다른 파일에서 import 하여 사용될 것입니다.
final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  // 개발 모드(debugMode)에서는 상세 로그를 출력하고,
  // 릴리즈 모드(releaseMode)에서는 경고(warning) 이상의 로그만 출력하도록 설정할 수 있습니다.
  level: kDebugMode ? Level.debug : Level.warning,
);