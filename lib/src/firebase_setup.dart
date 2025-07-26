// lib/firebase_setup.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart'; // WidgetsFlutterBinding.ensureInitialized() 때문에 필요

// Firebase 초기화 옵션 파일 (flutterfire configure 명령어로 생성됨)
import '../firebase_options.dart';
import 'package:fist_app/utils/app_logger.dart';
/// 앱 시작 시 Firebase를 초기화하는 함수.
Future<void> initializeFirebase() async {
  // Flutter 엔진이 위젯 바인딩을 초기화했는지 확인하여 Firebase 초기화 전 준비를 마칩니다.
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 앱 초기화.
  // DefaultFirebaseOptions.currentPlatform은 flutterfire configure 명령어로 생성된
  // firebase_options.dart 파일에 정의된 플랫폼별 Firebase 설정입니다.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ✅ Firebase 초기화 성공 로그 추가
    appLogger.i('Firebase가 성공적으로 초기화되었습니다.');
  } catch (e, s) {
    // ⛔ Firebase 초기화 실패 로그 추가
    appLogger.e('Firebase 초기화 중 오류 발생', error: e, stackTrace: s);
    // 앱이 Firebase 없이 동작할 수 없으므로, 필요하다면 여기서 앱을 종료하거나 오류 화면을 보여줄 수 있습니다.
    // print('Error initializing Firebase: $e'); // 기존 print 대신 로거 사용
  }
}