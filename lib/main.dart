//main.dirt
import 'package:flutter/material.dart';
import 'package:fist_app/services/firebase_setup.dart'; // Firebase 초기화 함수
import 'package:fist_app/widgets/loading_wrapper.dart'; // 💡 appLogger 사용을 위해 추가
import 'package:fist_app/services/app_initializer.dart';
void main() async {
  // Flutter 엔진이 위젯 바인딩을 초기화했는지 확인합니다.
  // 플러그인(예: Firebase)을 사용하기 전에 반드시 호출되어야 합니다.
  WidgetsFlutterBinding.ensureInitialized();

  await initializeFirebase();
  // 앱 로거 초기화 (선택 사항, 필요하다면)
  // appLogger.d('앱 시작: main() 함수 실행됨');
  await AppInitializer.initialize();
  // 앱의 최상위 위젯인 MyApp을 실행합니다.
  runApp(const MyApp()); // MyApp에 const를 붙일 수 있도록 아래에서 수정
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 💡 MyApp 생성자에 const를 추가하여 성능 최적화

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '나의 채팅 앱', // 앱의 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 색상 테마
        appBarTheme: const AppBarTheme( // AppBar 테마에 const 적용
          backgroundColor: Colors.blue, // AppBar 배경색
          foregroundColor: Colors.white, // AppBar 아이콘 및 텍스트 색상
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Material 3 디자인 시스템 사용 (선택 사항)
      ),
      debugShowCheckedModeBanner: false, // 💡 디버그 배너 숨김

      // Firebase 인증 상태에 따라 화면을 전환하는 로직
      home: const LoadingWrapper(),
    );
  }
}

// MyChatScreen 위젯은 현재 사용되지 않고 있지만, 나중에 메인 앱 화면으로 사용될 수 있습니다.
class MyChatScreen extends StatefulWidget {
  const MyChatScreen({super.key}); // 💡 생성자에 const 추가

  @override
  State<MyChatScreen> createState() => _MyChatScreenState();
}

class _MyChatScreenState extends State<MyChatScreen> {
  // 여기에 채팅 앱의 UI와 로직을 구현합니다.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chat App'), // 💡 const 적용
      ),
      body: const Center( // 💡 const 적용
        child: Text('그렇군d dd단순해!'), // 임시 텍스트
      ),
    );
  }
}