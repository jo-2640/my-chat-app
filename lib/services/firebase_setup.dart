// lib/firebase_setup.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:fist_app/firebase_options.dart';

/// 앱 시작 시 Firebase를 초기화하는 함수.
/// 이 함수는 WidgetsFlutterBinding.ensureInitialized() 호출 이후에 main.dart에서 호출됩니다.
Future<void> initializeFirebase() async {
  // WidgetsFlutterBinding.ensureInitialized()는 main.dart의 main 함수에서 호출되어야 합니다.
  // 이 함수 내에서는 제거합니다.

  // Firebase 앱 초기화.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}