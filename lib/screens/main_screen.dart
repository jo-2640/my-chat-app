import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 현재 사용자 정보에 접근하기 위해 필요
import 'package:fist_app/services/auth_service.dart'; // 로그아웃 기능을 위해 필요
import 'package:fist_app/main.dart';
import 'package:fist_app/utils/app_logger.dart';
// MainScreen을 StatefulWidget으로 변경합니다.
class MainScreen extends StatefulWidget {


  const MainScreen({
    super.key,

  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 로그아웃 처리 함수를 State 클래스 안으로 옮깁니다.
  Future<void> _logout() async { // context를 인자로 받지 않고, State의 context를 직접 사용합니다.
    appLogger.i('로그아웃 시도...');
    await AuthService.handleLogout(context); // context를 직접 전달 (AuthService가 필요하다면)
    appLogger.i('로그아웃 완료. AuthScreen으로 돌아감.');

    // 로그아웃 후 AuthScreen으로 돌아가기 위해 현재 스택을 모두 제거하고 AuthScreen을 푸시
    // context.mounted 체크는 비동기 작업 후 위젯이 여전히 트리에 있는지 확인하는 데 필수적입니다.
    if (mounted) { // StatefulWidget의 State에서는 'mounted' 속성을 직접 사용할 수 있습니다.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const MyApp()), // AuthScreen import 필요
            (route) => false, // 이전 모든 라우트 제거
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인된 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;

    appLogger.t('MainScreen build 메서드 호출됨');

    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout, // _logout 함수를 직접 연결합니다.
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                '로그인/회원가입 성공!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '환영합니다, ${user?.email ?? '손님'}님!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              if (user?.uid != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'UID: ${user!.uid}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _logout, // _logout 함수를 직접 연결합니다.
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
