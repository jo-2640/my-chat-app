import 'package:flutter/material.dart';
import 'package:fist_app/services/auth_service.dart'; // 인증 서비스 임포트
import 'package:fist_app/utils/app_logger.dart'; // 로거 임포트
import 'package:fist_app/utils/utils.dart'; // 유틸리티 함수 임포트 (showToast 포함 가정)
import 'package:fist_app/widgets/auth_email_input_field.dart';
import 'package:fist_app/widgets/auth_password_input_field.dart';
import 'package:fist_app/widgets/auth_mode_toggle_button.dart';
import 'package:fist_app/widgets/auth_submit_button.dart';
import 'package:fist_app/widgets/delete_all_data_button.dart';
// 기존에 AuthScreen에 직접 구현했던 필드들을 대체할 SignupFormFields 임포트
import 'package:fist_app/widgets/signup_form_field.dart'; // 파일명 확인: signup_form_fields.dart 또는 signup_form_field.dart
import 'dart:io'; // File 클래스를 위해 임포트 (ProfileImageUploader에서 사용될 수 있음)


class AuthScreen extends StatefulWidget {
  final Map<String, int> birthYearRange;
  final List<Map<String, String>> regions; // { 'value': 'seoul', 'label': '서울' } 형태

  const AuthScreen({
    super.key,
    required this.birthYearRange,
    required this.regions,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // --- 상태 변수 ---
  bool _isLoginMode = true; // 현재 인증 모드 (로그인 또는 회원가입)
  bool _isLoading = false; // 인증 처리 중 로딩 상태
  File? _pickedImage; // 선택된 프로필 이미지 파일

  // --- TextEditingController ---
  final _formKey = GlobalKey<FormState>(); // 폼의 상태를 관리하기 위한 GlobalKey
  final _emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러
  final _confirmPasswordController = TextEditingController(); // 비밀번호 확인 입력 컨트롤러
  final _nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  final _bioController = TextEditingController(); // 자기소개 입력 컨트롤러

  // --- DropdownButton 및 기타 회원가입 필드의 선택된 값 ---
  // SignUpFormFields에서 필요로 하는 상태들을 여기에 추가합니다.
  String? _selectedGender; // 선택된 성별
  String? _selectedBirthYear; // 선택된 생년월일 (SignUpFormFields에서는 String으로 받음)
  String? _selectedMinInterestAge; // 선택된 최소 관심 연령대
  String? _selectedMaxInterestAge; // 선택된 최대 관심 연령대
  String? _selectedRegion; // 선택된 지역 (SignUpFormFields에서는 String으로 받음)


  // --- 생명주기 메서드 ---
  @override
  void initState() {
    super.initState();
    appLogger.d('AuthScreen 초기화되고있다.');

    // 생년월일 범위가 주어졌을 경우, 기본값 설정 (예: 가장 최근 연도)
    if (widget.birthYearRange['start'] != null && widget.birthYearRange['end'] != null) {
      _selectedBirthYear = widget.birthYearRange['end']!.toString(); // String으로 변환하여 저장
    }
    // 지역 목록이 주어졌을 경우, 기본값 설정 (예: 첫 번째 지역의 value)
    if (widget.regions.isNotEmpty) {
      _selectedRegion = widget.regions.first['value'];
    }
    // 성별 기본값 설정 (선택 사항)
    _selectedGender = 'male'; // 예시: 'male', 'female', 'other' 중 하나
    // 관심 연령대 기본값 설정 (선택 사항)
    _selectedMinInterestAge = '20'; // 예시
    _selectedMaxInterestAge = '30'; // 예시
  }

  @override
  void dispose() {
    // 컨트롤러는 위젯이 dispose될 때 반드시 dispose 해주어야 메모리 누수를 방지할 수 있습니다.
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // --- UI 상호작용 관련 함수 ---
  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode; // 모드 전환
      appLogger.d('인증 모드 전환: ${_isLoginMode ? '로그인' : '회원가입'}');
      // 모드 전환 시 모든 입력 필드 초기화
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nicknameController.clear();
      _bioController.clear();
      _pickedImage = null; // 이미지도 초기화

      // 드롭다운 선택값도 초기화 (필요하다면)
      if (widget.birthYearRange['start'] != null && widget.birthYearRange['end'] != null) {
        _selectedBirthYear = widget.birthYearRange['end']!.toString();
      }
      if (widget.regions.isNotEmpty) {
        _selectedRegion = widget.regions.first['value'];
      }
      _selectedGender = 'male'; // 성별 기본값 재설정
      _selectedMinInterestAge = '20'; // 관심 연령대 기본값 재설정
      _selectedMaxInterestAge = '30'; // 관심 연령대 기본값 재설정
    });
  }

  // 프로필 이미지 변경 콜백 (ProfileImageUploader에서 호출됨)
  void _onImageChanged(File? imageFile) {
    setState(() {
      _pickedImage = imageFile;
    });
    appLogger.d('프로필 이미지 변경됨: ${imageFile?.path ?? "없음"}');
  }

  // 성별 드롭다운 변경 콜백
  void _onChangedGender(String? newValue) {
    setState(() {
      _selectedGender = newValue;
    });
    appLogger.d('선택된 성별: $newValue');
  }

  // 생년월일 드롭다운 변경 콜백
  void _onChangedBirthYear(String? newValue) {
    setState(() {
      _selectedBirthYear = newValue;
    });
    appLogger.d('선택된 생년월일: $newValue');
  }

  // 최소 관심 연령대 드롭다운 변경 콜백
  void _onChangedMinInterestAge(String? newValue) {
    setState(() {
      _selectedMinInterestAge = newValue;
    });
    appLogger.d('선택된 최소 관심 연령대: $newValue');
  }

  // 최대 관심 연령대 드롭다운 변경 콜백
  void _onChangedMaxInterestAge(String? newValue) {
    setState(() {
      _selectedMaxInterestAge = newValue;
    });
    appLogger.d('선택된 최대 관심 연령대: $newValue');
  }

  // 지역 드롭다운 변경 콜백
  void _onChangedRegion(String? newValue) {
    setState(() {
      _selectedRegion = newValue;
    });
    appLogger.d('선택된 지역: $newValue');
  }


  // 인증 폼 제출 함수 (로그인 또는 회원가입)
  Future<void> _submitAuthForm() async {
    // 폼 유효성 검사
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      appLogger.w('폼 유효성 검사 실패');
      return; // 유효성 검사 실패 시 함수 종료
    }

    // 회원가입 모드일 때 추가 유효성 검사
    if (!_isLoginMode) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showToast(context, '비밀번호와 비밀번호 확인이 일치하지 않습니다.', 'e');
        appLogger.w('비밀번호 불일치');
        return;
      }
      if (_nicknameController.text.isEmpty || _nicknameController.text.trim().length < 2) {
        showToast(context, '닉네임은 최소 2자 이상이어야 합니다.','e');
        appLogger.w('닉네임 유효성 검사 실패');
        return;
      }
      // ⚠️ 중요: 아래 필드들은 AuthService.handleSignup으로 전달되지 않습니다.
      // 이 데이터를 사용하려면 AuthService.handleSignup의 정의를 수정해야 합니다.
      if (_pickedImage == null) {
        showToast(context, '프로필 이미지를 선택하지않았습니다.','i');
        appLogger.w('프로필 이미지 미선택');
        return;
      }
      if (_selectedBirthYear == null) {
        showToast(context, '생년월일을 선택해주세요.','e');
        appLogger.w('생년월일 미선택');
        return;
      }
      if (_selectedRegion == null || _selectedRegion!.isEmpty) {
        showToast(context, '지역을 선택해주세요.','e');
        appLogger.w('지역 미선택');
        return;
      }
      if (_selectedGender == null || _selectedGender!.isEmpty) {
        showToast(context, '성별을 선택해주세요.','e');
        appLogger.w('성별 미선택');
        return;
      }
      if (_selectedMinInterestAge == null || _selectedMaxInterestAge == null) {
        showToast(context, '관심 연령대를 선택해주세요.','e');
        appLogger.w('관심 연령대 미선택');
        return;
      }
      // 관심 연령대 범위 유효성 검사
      if (int.parse(_selectedMinInterestAge!) > int.parse(_selectedMaxInterestAge!)) {
        showToast(context, '최소 관심 연령대가 최대 관심 연령대보다 클 수 없습니다.','e');
        appLogger.w('관심 연령대 범위 오류');
        return;
      }
    }

    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    try {
      if (_isLoginMode) {
        // 로그인 로직
        appLogger.i('로그인 시도: ${_emailController.text}');

        String? errorMessage = await AuthService.handleLogin(
          _emailController.text.trim(), // 실제 이메일 텍스트 전달
          _passwordController.text.trim(), // 실제 비밀번호 텍스트 전달
        );
        if (errorMessage != null) {
          // 로그인 실패 시 에러 메시지 표시
          if(!mounted) return;
          showToast(context, errorMessage,'e');
        } else {
          // 로그인 성공 시 처리
          if(!mounted) return;
          showToast(context, '로그인 성공!','s');
          // TODO: 메인 화면으로 이동 등 (예: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen())));
        }
      } else { // 회원가입 로직
        appLogger.i('회원가입 시도: ${_emailController.text}'); // 실제 이메일 텍스트 로깅

        // ⚠️ 경고: AuthService.handleSignup이 3개의 인자만 받도록 수정되었습니다.
        // 따라서 아래 주석 처리된 나머지 인자들은 전달되지 않습니다.
        // 모든 회원가입 데이터를 보내려면 AuthService.handleSignup의 정의를 수정해야 합니다.
        await AuthService.handleSignup(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nicknameController.text.trim(),
          // _bioController.text.trim(),
          // int.parse(_selectedBirthYear!),
          // _selectedRegion!,
          // _pickedImage!,
          // _selectedGender!,
          // int.parse(_selectedMinInterestAge!),
          // int.parse(_selectedMaxInterestAge!),
        );
        if(!mounted) return;
        showToast(context, '회원가입 성공!','s');
        appLogger.i('회원가입 성공');
        // 회원가입 성공 후 로그인 모드로 자동 전환 또는 다음 화면으로 이동
        _toggleAuthMode(); // 회원가입 성공 후 로그인 모드로 전환
      }
    } catch (error) {
      // 에러 처리
      appLogger.e('인증 오류: $error');
      String errorMessage = '인증에 실패했습니다. 다시 시도해주세요.';
      // 에러 메시지 내용에 따라 구체적인 메시지 표시
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = '이미 존재하는 이메일 주소입니다.';
      } else if (error.toString().contains('INVALID_LOGIN_CREDENTIALS')) {
        errorMessage = '이메일 또는 비밀번호가 올바르지 않습니다.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = '비밀번호가 너무 약합니다.';
      }
      if(!mounted) return;
      showToast(context, errorMessage,'e'); // 사용자에게 에러 메시지 표시
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appLogger.t('AuthScreen build 메서드 호출됨');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? '로그인' : '회원가입'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // 컬럼이 차지하는 공간을 최소화
              children: [
                // 이메일 입력 필드
                AuthEmailInputField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return '올바른 이메일 주소를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 비밀번호 입력 필드
                AuthPasswordInputField(
                  controller: _passwordController,
                  initialObscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return '비밀번호는 최소 6자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // SignUpFormFields 위젯을 사용하여 회원가입 관련 필드들을 렌더링
                // isLoginMode가 false일 때만 SignUpFormFields가 보이도록 내부에서 처리
                SignUpFormFields(
                  isLoginMode: _isLoginMode,
                  confirmPasswordController: _confirmPasswordController,
                  mainPasswordController: _passwordController, // 메인 비밀번호 컨트롤러 전달
                  nicknameController: _nicknameController,
                  bioController: _bioController,
                  selectedGender: _selectedGender,
                  onChangedGender: _onChangedGender,
                  selectedBirthYear: _selectedBirthYear,
                  minYear: widget.birthYearRange['start'] ?? 1900, // int 값을 전달
                  maxYear: widget.birthYearRange['end'] ?? 2000,   // int 값을 전달
                  onChangedBirthYear: _onChangedBirthYear,
                  selectedMinInterestAge: _selectedMinInterestAge,
                  onChangedMinInterestAge: _onChangedMinInterestAge,
                  selectedMaxInterestAge: _selectedMaxInterestAge,
                  onChangedMaxInterestAge: _onChangedMaxInterestAge,
                  selectedRegion: _selectedRegion,
                  onChangedRegion: _onChangedRegion,
                  regions: widget.regions,
                  onImageChanged: _onImageChanged ,
                ),

                // 제출 버튼
                SizedBox(
                  width: 250,
                  child: _isLoading // 로딩 중일 때 로딩 인디케이터 표시
                      ? const CircularProgressIndicator()
                      : AuthSubmitButton(
                    isLoginMode: _isLoginMode,
                    onSubmit: _submitAuthForm,
                  ),
                ),
                const SizedBox(height: 16),

                // 모드 전환 버튼
                SizedBox(
                  width: 250,
                  child: AuthModeToggleButton(
                    isLoginMode: _isLoginMode,
                    isLoading: _isLoading, // 로딩 중일 때 버튼 비활성화
                    onToggleMode: _toggleAuthMode,
                  ),
                ),
                const SizedBox(height: 32),

                // 모든 데이터 삭제 버튼
                DeleteAllDataButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
