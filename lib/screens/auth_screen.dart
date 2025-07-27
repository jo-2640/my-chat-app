import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 사용을 위해 추가
import 'package:fist_app/provider/auth_provider.dart'; // AuthProvider 임포트
import 'package:fist_app/utils/app_logger.dart'; // 로거 임포트
import 'package:fist_app/utils/utils.dart'; // 유틸리티 함수 임포트 (showToast 포함 가정)
import 'package:fist_app/widgets/auth_email_input_field.dart';
import 'package:fist_app/widgets/auth_password_input_field.dart';
import 'package:fist_app/widgets/auth_mode_toggle_button.dart';
import 'package:fist_app/widgets/auth_submit_button.dart';
import 'package:fist_app/widgets/delete_all_data_button.dart';
import 'package:fist_app/widgets/signup_form_field.dart'; // 파일명 확인: signup_form_fields.dart 또는 signup_form_field.dart
// import 'dart:io'; // File 클래스는 AuthProvider가 관리하므로 여기서 직접 필요 없습니다.


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key}); // AuthScreen은 더 이상 Prop을 받지 않습니다.

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사를 위한 GlobalKey (이것만 AuthScreen에 유지)

  @override
  void initState() {
    super.initState();
    appLogger.d('AuthScreen 초기화되고있다.');
    // AuthProvider에서 모든 초기화 로직이 처리되므로,
    // 이곳에서 로컬 상태를 초기화할 필요가 없습니다.
  }

  @override
  void dispose() {
    // AuthProvider가 TextEditingController들을 관리하고 dispose하므로,
    // 이곳에서 직접 dispose할 필요가 없습니다.
    super.dispose();
  }

  // --- 폼 제출 로직 ---
  // 이 함수는 AuthProvider의 메서드를 호출하고, 유효성 검사 및 결과 처리를 담당합니다.
  Future<void> _submitAuthForm(BuildContext context) async {
    // context.read<AuthProvider>()는 Provider의 메서드(action)를 호출할 때 사용합니다.
    final authProvider = context.read<AuthProvider>();

    // 폼 유효성 검사 (각 TextFormField의 validator 실행)
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      appLogger.w('폼 유효성 검사 실패');
      return;
    }

    // AuthProvider의 isLoginMode를 사용하여 회원가입 모드일 때 추가 유효성 검사 수행
    if (!authProvider.isLoginMode) {
      // AuthProvider의 컨트롤러와 선택된 값들을 사용하여 유효성 검사
      if (authProvider.passwordController.text != authProvider.confirmPasswordController.text) {
        showToast(context, '비밀번호와 비밀번호 확인이 일치하지 않습니다.', 'e');
        appLogger.w('비밀번호 불일치');
        return;
      }
      if (authProvider.nicknameController.text.isEmpty || authProvider.nicknameController.text.trim().length < 2) {
        showToast(context, '닉네임은 최소 2자 이상이어야 합니다.', 'e');
        appLogger.w('닉네임 유효성 검사 실패');
        return;
      }
      if (authProvider.profileImage == null) {
        showToast(context, '프로필 이미지를 선택하지않았습니다.', 'i');
        appLogger.w('프로필 이미지 미선택');
        return;
      }
      if (authProvider.selectedBirthYear == null) {
        showToast(context, '생년월일을 선택해주세요.', 'e');
        appLogger.w('생년월일 미선택');
        return;
      }
      if (authProvider.selectedRegion == null || authProvider.selectedRegion!.isEmpty) {
        showToast(context, '지역을 선택해주세요.', 'e');
        appLogger.w('지역 미선택');
        return;
      }
      if (authProvider.selectedGender == null || authProvider.selectedGender!.isEmpty) {
        showToast(context, '성별을 선택해주세요.', 'e');
        appLogger.w('성별 미선택');
        return;
      }
      if (authProvider.selectedMinInterestAge == null || authProvider.selectedMaxInterestAge == null) {
        showToast(context, '관심 연령대를 선택해주세요.', 'e');
        appLogger.w('관심 연령대 미선택');
        return;
      }
      if (int.parse(authProvider.selectedMinInterestAge!) > int.parse(authProvider.selectedMaxInterestAge!)) {
        showToast(context, '최소 관심 연령대가 최대 관심 연령대보다 클 수 없습니다.', 'e');
        appLogger.w('관심 연령대 범위 오류');
        return;
      }
    }

    try {
      if (authProvider.isLoginMode) {
        appLogger.i('로그인 시도: ${authProvider.emailController.text}');
        await authProvider.login(); // AuthProvider의 로그인 메서드 호출
        appLogger.i('로그인 성공 : $authProvider.errorMessage!');
      } else { // 회원가입 로직
        appLogger.i('회원가입 시도: ${authProvider.emailController.text}');
        await authProvider.signup(); // AuthProvider의 회원가입 메서드 호출
        appLogger.i('회원가입 성공:$authProvider.errorMessage!');
      }
    } catch (error) {
      // AuthProvider에서 이미 에러 메시지를 설정하고 토스트를 띄울 수 있으므로
      // 여기서는 추가적인 에러 처리 로직이 필요 없을 수 있습니다.
      appLogger.e('인증 과정에서 최종 오류 발생: $error');
      if (authProvider.errorMessage != null && mounted) {
        appLogger.e('$authProvider.errorMessage!' );
      } else if (mounted) {
        appLogger.e('$authProvider.errorMessage 알 수 없는 인증 오류가 발생했습니다.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    appLogger.t('AuthScreen build 메서드 호출됨');

    // AuthProvider의 상태를 '지켜보기'
    // context.watch<AuthProvider>()를 사용하여 상태 변화를 감지하고 UI를 업데이트합니다.
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(authProvider.isLoginMode ? '로그인' : '회원가입'), // AuthProvider의 isLoginMode 사용
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 이메일 입력 필드
                AuthEmailInputField(
                  controller: authProvider.emailController, // AuthProvider의 컨트롤러 사용
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
                  controller: authProvider.passwordController, // AuthProvider의 컨트롤러 사용
                  initialObscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return '비밀번호는 최소 6자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // SignUpFormFields도 이제 AuthProvider의 컨트롤러와 업데이트 메서드를 사용
                SignUpFormFields(
                  isLoginMode: authProvider.isLoginMode, // AuthProvider의 isLoginMode 사용
                  confirmPasswordController: authProvider.confirmPasswordController, // AuthProvider의 컨트롤러 사용
                  mainPasswordController: authProvider.passwordController, // AuthProvider의 컨트롤러 사용
                  nicknameController: authProvider.nicknameController, // AuthProvider의 컨트롤러 사용
                  bioController: authProvider.bioController, // AuthProvider의 컨트롤러 사용
                  selectedGender: authProvider.selectedGender, // AuthProvider의 상태 사용
                  onChangedGender: authProvider.updateSelectedGender, // AuthProvider의 메서드 호출
                  selectedBirthYear: authProvider.selectedBirthYear, // AuthProvider의 상태 사용
                  minYear: authProvider.getBirthYearRange['minYear']?.toInt() ?? 1900, // AuthProvider의 getter 사용
                  maxYear: authProvider.getBirthYearRange['maxYear']?.toInt() ?? DateTime.now().year, // AuthProvider의 getter 사용
                  onChangedBirthYear: authProvider.updateSelectedBirthYear, // AuthProvider의 메서드 호출
                  selectedMinInterestAge: authProvider.selectedMinInterestAge, // AuthProvider의 상태 사용
                  onChangedMinInterestAge: authProvider.updateSelectedMinInterestAge, // AuthProvider의 메서드 호출
                  selectedMaxInterestAge: authProvider.selectedMaxInterestAge, // AuthProvider의 상태 사용
                  onChangedMaxInterestAge: authProvider.updateSelectedMaxInterestAge, // AuthProvider의 메서드 호출
                  selectedRegion: authProvider.selectedRegion, // AuthProvider의 상태 사용
                  onChangedRegion: authProvider.updateSelectedRegion, // AuthProvider의 메서드 호출
                  regions: authProvider.regions, // AuthProvider의 데이터 사용
                  onImageChanged: authProvider.updateProfileImage, // AuthProvider의 메서드 호출
                    authProvider: authProvider,
                ),

                SizedBox(
                  width: 250,
                  child: authProvider.isLoading // AuthProvider의 로딩 상태 사용
                      ? const CircularProgressIndicator()
                      : AuthSubmitButton(
                    isLoginMode: authProvider.isLoginMode, // AuthProvider의 isLoginMode 사용
                    onSubmit: () => _submitAuthForm(context), // context를 전달하도록 변경
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: 250,
                  child: AuthModeToggleButton(
                    isLoginMode: authProvider.isLoginMode, // AuthProvider의 isLoginMode 사용
                    isLoading: authProvider.isLoading, // AuthProvider의 로딩 상태 사용
                    onToggleMode: authProvider.toggleAuthMode, // AuthProvider의 메서드 호출
                  ),
                ),
                const SizedBox(height: 32),

                DeleteAllDataButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}