// lib/providers/auth_provider.dart

import 'package:fist_app/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:fist_app/services/auth_service.dart';
import 'dart:io';
import 'package:fist_app/utils/age_group_utils.dart'; // AgeGroupUtils 임포트 확인

class AuthProvider with ChangeNotifier {
  // --- 인증 관련 상태 ---
  bool _isLoginMode = true; // 현재 인증 모드 (로그인/회원가입)
  bool get isLoginMode => _isLoginMode;

  bool _isLoading = false; // API 호출 로딩 상태
  bool get isLoading => _isLoading;

  String? _errorMessage; // API 호출 실패 시 에러 메시지
  String? get errorMessage => _errorMessage;

  // --- 폼 필드 컨트롤러 ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // --- 드롭다운 선택된 값 및 이미지 파일 ---
  String? _selectedGender;
  String? get selectedGender => _selectedGender;

  String? _selectedBirthYear;
  String? get selectedBirthYear => _selectedBirthYear;

  String? _selectedMinInterestAge;
  String? get selectedMinInterestAge => _selectedMinInterestAge;

  String? _selectedMaxInterestAge;
  String? get selectedMaxInterestAge => _selectedMaxInterestAge;

  String? _selectedRegion;
  String? get selectedRegion => _selectedRegion;

  File? _profileImage;
  File? get profileImage => _profileImage;

  // --- 외부에서 주입받는 초기 데이터 (final로 선언) ---
  final List<Map<String, String>> regions; // 지역 목록
  final Map<String, int> _birthYearRange; // 생년월일 범위 (프라이빗 필드로 저장)
  final List<String> ageGroupOptions; // ConfigService에서 받은 List<String> (여기서는 직접 사용하지 않음)

  Map<String, int> get getBirthYearRange => _birthYearRange;

  // --- 생성자: 초기값 설정 ---
  AuthProvider({
    required Map<String, int> birthYearRange,
    required this.regions,
    required this.ageGroupOptions, // LoadingWrapper에서 전달하기에 유지합니다.
  }) : _birthYearRange = birthYearRange {
    // 생년월일 초기값 설정 (최대 연도)
    if (_birthYearRange['maxYear'] != null) {
      _selectedBirthYear = _birthYearRange['maxYear'].toString();
    }
    // 지역 초기값 설정 (첫 번째 지역)
    if (regions.isNotEmpty) {
      _selectedRegion = regions.first['value'];
    }
    // 성별 초기값 설정
    _selectedGender = 'female';

    // 관심 연령대 초기값 설정: AgeGroupUtils.detailedAgeGroupsFlutter를 기준으로 설정
    // 10대 이하 ~ 60대 이상으로 초기 범위 설정
    if (AgeGroupUtils.detailedAgeGroupsFlutter.isNotEmpty) {
      _selectedMinInterestAge = AgeGroupUtils.detailedAgeGroupsFlutter.first.value;
      _selectedMaxInterestAge = AgeGroupUtils.detailedAgeGroupsFlutter.last.value;
    } else {
      _selectedMinInterestAge = '10-under';
      _selectedMaxInterestAge = '60-plus';
    }
  }

  // --- 연령대 드롭다운 옵션 목록을 동적으로 가져오는 Getter ---
  // 이제 항상 전체 리스트를 반환하여, 드롭다운을 열었을 때 모든 옵션이 보이도록 합니다.
  List<AgeGroup> get minAgeGroupOptions {
    return AgeGroupUtils.detailedAgeGroupsFlutter; // ✨ 항상 전체 리스트 반환
  }

  List<AgeGroup> get maxAgeGroupOptions {
    return AgeGroupUtils.detailedAgeGroupsFlutter; // ✨ 항상 전체 리스트 반환
  }

  // --- 상태 업데이트 메서드 ---

  void updateSelectedGender(String? value) {
    _selectedGender = value;
    notifyListeners();
  }

  void updateSelectedBirthYear(String? value) {
    _selectedBirthYear = value;
    notifyListeners();
  }

  void updateSelectedMinInterestAge(String? value) {
    if (value == null) return;

    _selectedMinInterestAge = value;
    final newMinIndex = AgeGroupUtils.getAgeGroupIndex(value);
    final currentMaxIndex = _selectedMaxInterestAge != null
        ? AgeGroupUtils.getAgeGroupIndex(_selectedMaxInterestAge!)
        : -1; // null일 경우 유효하지 않은 인덱스

    // ✨ '10대 이하' 또는 '60대 이상' 선택 시 최대 연령대도 동일하게 고정
    if (value == "10-under" || value == "60-plus") {
      _selectedMaxInterestAge = value;
    }
    // ✨ 일반 연령대 선택 시, 최소가 최대를 넘어서면 최대를 최소와 동일하게 조정
    else {
      // 현재 최대가 null이거나, 새로운 최소가 현재 최대보다 크면, 최대를 새로운 최소로 설정
      if (currentMaxIndex == -1 || newMinIndex > currentMaxIndex) {
        _selectedMaxInterestAge = value;
      }
    }
    notifyListeners();
  }

  void updateSelectedMaxInterestAge(String? value) {
    if (value == null) return;

    _selectedMaxInterestAge = value;
    final newMaxIndex = AgeGroupUtils.getAgeGroupIndex(value);
    final currentMinIndex = _selectedMinInterestAge != null
        ? AgeGroupUtils.getAgeGroupIndex(_selectedMinInterestAge!)
        : -1; // null일 경우 유효하지 않은 인덱스

    // ✨ '10대 이하' 또는 '60대 이상' 선택 시 최소 연령대도 동일하게 고정
    if (value == "10-under" || value == "60-plus") {
      _selectedMinInterestAge = value;
    }
    // ✨ 일반 연령대 선택 시, 최대가 최소보다 작아지면 최소를 최대와 동일하게 조정
    else {
      // 현재 최소가 null이거나, 새로운 최대가 현재 최소보다 작으면, 최소를 새로운 최대로 설정
      if (currentMinIndex == -1 || newMaxIndex < currentMinIndex) {
        _selectedMinInterestAge = value;
      }
    }
    notifyListeners();
  }

  void updateSelectedRegion(String? value) {
    _selectedRegion = value;
    notifyListeners();
  }

  void updateProfileImage(File? image) {
    _profileImage = image;
    notifyListeners();
  }

  // --- 인증 모드 전환 및 필드 초기화 ---

  void toggleAuthMode() {
    _isLoginMode = !_isLoginMode;
    _errorMessage = null; // 모드 전환 시 에러 메시지 초기화

    // 모든 텍스트 컨트롤러 초기화
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nicknameController.clear();
    bioController.clear();
    _profileImage = null; // 프로필 이미지 초기화

    // 드롭다운 선택값들을 초기 기본값으로 재설정
    if (_birthYearRange['maxYear'] != null) {
      _selectedBirthYear = _birthYearRange['maxYear'].toString();
    }
    if (regions.isNotEmpty) {
      _selectedRegion = regions.first['value'];
    }
    _selectedGender = 'female';

    // 토글 시 관심 연령대 초기값 재설정: AgeGroupUtils.detailedAgeGroupsFlutter를 기준으로 설정
    if (AgeGroupUtils.detailedAgeGroupsFlutter.isNotEmpty) {
      _selectedMinInterestAge = AgeGroupUtils.detailedAgeGroupsFlutter.first.value; // 10대 이하
      _selectedMaxInterestAge = AgeGroupUtils.detailedAgeGroupsFlutter.last.value;  // 60대 이상
    } else {
      _selectedMinInterestAge = '10-under';
      _selectedMaxInterestAge = '60-plus';
    }

    notifyListeners(); // 상태 변경 알림
  }

  // --- 로그인 로직 ---

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String? apiErrorMessage = await AuthService.handleLogin(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (apiErrorMessage != null) {
        _errorMessage = apiErrorMessage;
      } else {
        appLogger.d('로그인성공: $_errorMessage');
        _errorMessage = null; // 성공 시 에러 메시지 제거
      }
    } catch (e) {
      // 에러 메시지 파싱 (콜론 ':' 다음의 메시지 추출)
      _errorMessage = e.toString().contains(':') ? e.toString().split(':')[1].trim() : e.toString();
      appLogger.d('로그인 실패: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 회원가입 로직 ---

  Future<void> signup() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 클라이언트 측 유효성 검사 (API 호출 전)
    if (passwordController.text != confirmPasswordController.text) {
      _errorMessage = '비밀번호가 일치하지 않습니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (nicknameController.text.isEmpty || nicknameController.text.trim().length < 2) {
      _errorMessage = '닉네임은 최소 2자 이상이어야 합니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (_profileImage == null) {
      _errorMessage = '프로필 이미지를 선택해주세요.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    if (_selectedBirthYear == null || _selectedRegion == null || _selectedGender == null ||
        _selectedMinInterestAge == null || _selectedMaxInterestAge == null) {
      _errorMessage = '모든 필수 정보를 입력해주세요.';
      _isLoading = false;
      notifyListeners();
      return;
    }
    // 최종 유효성 검사: 최소 연령대가 최대 연령대보다 클 수 없음 (AgeGroupUtils.getAgeGroupIndex 사용)
    final minIndex = AgeGroupUtils.getAgeGroupIndex(_selectedMinInterestAge!);
    final maxIndex = AgeGroupUtils.getAgeGroupIndex(_selectedMaxInterestAge!);
    if (minIndex != -1 && maxIndex != -1 && minIndex > maxIndex) {
      _errorMessage = '최소 관심 연령대가 최대 관심 연령대보다 클 수 없습니다.';
      _isLoading = false;
      notifyListeners();
      return;
    }


    try {
      await AuthService.handleSignup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        nickname: nicknameController.text.trim(),
        bio: bioController.text.trim(),
        birthYear: _selectedBirthYear!,
        region: _selectedRegion!,
        profileImage: _profileImage!,
        gender: _selectedGender!,
        minInterestAge: _selectedMinInterestAge!,
        maxInterestAge: _selectedMaxInterestAge!,
      );
      _errorMessage = null; // 성공 시 에러 메시지 제거
      _isLoginMode = true; // 회원가입 성공 후 로그인 모드로 자동 전환
      notifyListeners(); // 상태 변경 알림
      appLogger.i('회원가입 성공');

    } catch (e) {
      // 에러 메시지 파싱
      _errorMessage = e.toString().contains(':') ? e.toString().split(':')[1].trim() : e.toString();
      appLogger.i('회원가입 실패 :$_errorMessage');
      if (_errorMessage!.contains('EMAIL_EXISTS')) {
        _errorMessage = '이미 존재하는 이메일 주소입니다.';
      } else if (_errorMessage!.contains('WEAK_PASSWORD')) {
        _errorMessage = '비밀번호가 너무 약합니다.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 리소스 해제 (동일) ---

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nicknameController.dispose();
    bioController.dispose();
    super.dispose();
  }
}