// lib/widgets/loading_wrapper.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fist_app/services/auth_service.dart'; // AuthService 임포트
import 'package:fist_app/services/config_service.dart'; // ConfigService 임포트
import 'package:fist_app/screens/auth_screen.dart'; // AuthScreen 임포트
import 'package:fist_app/screens/main_screen.dart'; // MyChatScreen 임포트
import 'package:fist_app/utils/app_logger.dart'; // appLogger 임포트
import 'package:fist_app/provider/auth_provider.dart'; //
class LoadingWrapper extends StatefulWidget {
  const LoadingWrapper({super.key});

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}
//서버로부터 받을 비동기 자료들.
class _LoadingWrapperState extends State<LoadingWrapper> {
  // ConfigService에서 가져올 연도 범위 데이터를 저장할 변수
  late Map<String, int> _birthYearRange; //서버로부터 받을 회원가입 출생연도 범위
  late List<Map<String, String>> _regions = []; // ✨ 지역 목록을 저장할 변수 추가
  late List<String> _ageGroupOptions; // ✨ 이 변수가 여기에 선언되어 있습니다.
  // 초기화 및 데이터 로딩 작업의 완료 여부
  bool _isInitialized = false;
  // 로딩 중 발생한 오류 메시지 (선택 사항)
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAppData(); // 앱 시작 시 필요한 데이터 로딩 시작
  }

  // 앱 초기화 및 데이터 로딩을 위한 비동기 함수
  Future<void> _initializeAppData() async {
    try {
      // 1. ConfigService에서 탄생 연도 범위 데이터 로드(비동기-서버)
      final range = await ConfigService.getBirthYearRange();
      if (range == null) {
        throw Exception('Failed to load birth year range from server.');
      }
      _birthYearRange = range;
      appLogger.i('앱 초기화: 탄생 연도 범위 로드 성공');

      // 2. ConfigService에서 지역 목록 데이터 로드 (동기-클라우드)
      _regions = ConfigService.getRegions(); // ✨ 지역 목록 로드
      if (_regions.isEmpty) {
        // 지역 데이터가 없으면 경고 또는 에러 처리
        appLogger.w('앱 초기화: 지역 목록이 비어 있습니다. .env 파일을 확인하세요.');
        // 필수 데이터라면 throw Exception('Failed to load regions.'); 와 같이 에러 처리
      } else {
        appLogger.i('앱 초기화: 지역 목록 로드 성공 (총 ${_regions.length}개)');
      }
      _ageGroupOptions = ConfigService.getAgeGroupOptions();
      if (_ageGroupOptions.isEmpty) {
        appLogger.w('앱 초기화: 관심 연령대 옵션이 비어 있습니다. .env 파일을 확인하세요.');
      } else {
        appLogger.i('앱 초기화: 관심 연령대 옵션 로드 성공 (총 ${_ageGroupOptions.length}개)');
      }
      setState(() {
        _isInitialized = true; // 모든 초기화 작업 완료 플래그 설정
      });
    } catch (e, s) {
      appLogger.e('앱 초기화 실패:', error: e, stackTrace: s);
      setState(() {
        _errorMessage = '앱 초기화 중 오류가 발생했습니다: $e'; // 사용자에게 보여줄 오류 메시지 저장
        _isInitialized = true; // 오류가 났어도 초기화 시도는 완료된 것으로 간주
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 아직 초기화 중이라면 로딩 화면 표시
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 초기화 중 오류가 발생했다면 오류 메시지 화면 표시
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 10),
                Text(
                  '오류: $_errorMessage\n앱을 다시 시작하거나 관리자에게 문의하세요.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // 재시도 로직 (예: 다시 _initializeAppData() 호출)
                    setState(() {
                      _isInitialized = false; // 다시 로딩 상태로 변경
                      _errorMessage = null;   // 오류 메시지 초기화
                    });
                    _initializeAppData();
                  },
                  child: const Text('재시도'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 모든 초기화가 성공적으로 완료된 후, 인증 상태에 따라 실제 앱 화면 분기
    return StreamBuilder(
      stream: AuthService.auth.authStateChanges(), // Firebase Auth의 상태 변화 스트림
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Firebase Auth 스트림 대기 중
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          // 사용자가 로그인되어 있음
          final user = snapshot.data;
          appLogger.i('사용자 로그인됨: ${user?.uid ?? "Unknown UID"}');
          // 로그인된 사용자를 위한 메인 앱 화면으로 이동
          // MyChatScreen에 로드된 연도 범위 데이터를 전달해야 한다면?
          // 예: MyChatScreen(birthYearRange: _birthYearRange)
          return const MainScreen();
        }
        // 사용자가 로그인되어 있지 않음 (AuthScreen으로 이동)
        // AuthScreen에 로드된 연도 범위 데이터를 전달합니다!
        return ChangeNotifierProvider(
          create: (ctx) => AuthProvider(
            birthYearRange: _birthYearRange,
            regions: _regions,
            ageGroupOptions: _ageGroupOptions,
          ),
          child: const AuthScreen(),
        );
      },
    );
  }
}