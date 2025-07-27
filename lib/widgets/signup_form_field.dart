// lib/widgets/signup_form_fields.dart

import 'package:flutter/material.dart';
import 'package:fist_app/utils/random_data_generator.dart'; // 랜덤 데이터 유틸리티
import 'package:fist_app/utils/age_group_utils.dart'; // AgeGroupUtils
import 'package:fist_app/widgets/auth_confirm_password_input_field.dart';
import 'package:fist_app/widgets/auth_nickname_input_field.dart';
import 'package:fist_app/widgets/auth_gender_dropdown_field.dart';
import 'package:fist_app/widgets/auth_birth_year_dropdown_field.dart';
import 'package:fist_app/widgets/age_group_dropdown_field.dart';
import 'package:fist_app/widgets/region_dropdown_field.dart';
import 'package:fist_app/widgets/profile_image_uploader.dart';
import 'package:fist_app/provider/auth_provider.dart' as app_auth_provider; // AuthProvider 별칭 사용
import 'dart:io';
import 'dart:math';

class SignUpFormFields extends StatefulWidget {
  final bool isLoginMode;
  final TextEditingController confirmPasswordController;
  final TextEditingController mainPasswordController;
  final TextEditingController nicknameController;
  final String? selectedGender;
  final void Function(String?) onChangedGender;
  final String? selectedBirthYear;
  final int minYear;
  final int maxYear;
  final void Function(String?) onChangedBirthYear;
  final String? selectedMinInterestAge;
  final void Function(String?) onChangedMinInterestAge;
  final String? selectedMaxInterestAge;
  final void Function(String?) onChangedMaxInterestAge;
  final String? selectedRegion;
  final void Function(String?) onChangedRegion;
  final List<Map<String,String>> regions;
  final TextEditingController bioController;
  final void Function(File?) onImageChanged;
  final app_auth_provider.AuthProvider authProvider;

  const SignUpFormFields({
    super.key,
    required this.isLoginMode,
    required this.confirmPasswordController,
    required this.mainPasswordController,
    required this.nicknameController,
    required this.selectedGender,
    required this.onChangedGender,
    required this.selectedBirthYear,
    required this.minYear,
    required this.maxYear,
    required this.onChangedBirthYear,
    required this.selectedMinInterestAge,
    required this.onChangedMinInterestAge,
    required this.selectedMaxInterestAge,
    required this.onChangedMaxInterestAge,
    required this.selectedRegion,
    required this.onChangedRegion,
    required this.regions,
    required this.bioController,
    required this.onImageChanged,
    required this.authProvider,
  });

  @override
  State<SignUpFormFields> createState() => _SignUpFormFieldsState();
}

class _SignUpFormFieldsState extends State<SignUpFormFields> {
  final Random _rnd = Random();
  final List<AgeGroup> _detailedAgeGroups = AgeGroupUtils.detailedAgeGroupsFlutter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fillSignUpFieldsWithRandomData() {
    final int minBirthYear = widget.minYear;
    final int maxBirthYear = widget.maxYear;

    // setState를 호출하여 UI를 업데이트합니다.
    setState(() {
      // AuthProvider의 컨트롤러에 직접 값을 설정
      widget.authProvider.emailController.text = generateRandomEmail();
      widget.authProvider.passwordController.text = 'password123';
      widget.authProvider.confirmPasswordController.text = 'password123';
      widget.authProvider.nicknameController.text = generateRandomString(8);
      widget.authProvider.bioController.text = "안녕하세요! 랜덤으로 생성된 자기소개입니다.";

      // Dropdown 값 업데이트 (AuthProvider의 update 메서드 호출)
      widget.onChangedGender(getRandomElement(['male', 'female']));

      final int randomBirthYear = minBirthYear + _rnd.nextInt(maxBirthYear - minBirthYear + 1);
      widget.onChangedBirthYear(randomBirthYear.toString());

      if (widget.regions.isNotEmpty) {
        // regions는 List<Map<String, String>> 형태이므로, 'value'를 가져와야 합니다.
        widget.onChangedRegion(getRandomElement(widget.regions)['value']);
      }

      // ⭐⭐⭐ 나이대 랜덤 선택 로직 수정: 특별 규칙 및 범위 제약을 직접 적용 ⭐⭐⭐
      if (_detailedAgeGroups.isNotEmpty) {
        // 1. 먼저 최소 연령대를 랜덤으로 선택합니다.
        int randomIndexMin = _rnd.nextInt(_detailedAgeGroups.length);
        String selectedMinAge = _detailedAgeGroups[randomIndexMin].value;

        String selectedMaxAge;
        // 2. 선택된 최소 연령대가 특별 케이스인지 확인합니다.
        if (selectedMinAge == "10-under" || selectedMinAge == "60-plus") {
          // 특별 케이스인 경우, 최대 연령대도 동일하게 고정합니다.
          selectedMaxAge = selectedMinAge;
        } else {
          // 3. 일반 연령대인 경우, 최소 연령대 이상인 범위 내에서 최대 연령대를 랜덤으로 선택합니다.
          // 최대 연령대가 될 수 있는 최소 인덱스는 현재 선택된 최소 연령대의 인덱스입니다.
          int minAllowedMaxIndex = randomIndexMin;
          // 최대 연령대가 될 수 있는 최대 인덱스는 전체 리스트의 마지막 인덱스입니다.
          int maxPossibleMaxIndex = _detailedAgeGroups.length - 1;

          // minAllowedMaxIndex부터 maxPossibleMaxIndex까지의 범위에서 랜덤으로 선택
          int randomIndexMax = minAllowedMaxIndex + _rnd.nextInt(maxPossibleMaxIndex - minAllowedMaxIndex + 1);
          selectedMaxAge = _detailedAgeGroups[randomIndexMax].value;
        }

        // AuthProvider의 update 메서드를 통해 값 설정
        // 이 순서가 중요합니다: 먼저 최소를 설정하고, 그 다음 최대를 설정합니다.
        // AuthProvider의 로직이 이 값들을 기반으로 최종 유효성 검사 및 조정을 수행합니다.
        widget.onChangedMinInterestAge(selectedMinAge);
        widget.onChangedMaxInterestAge(selectedMaxAge);
      }
      // 프로필 이미지는 랜덤으로 선택하기 어렵고, Uploader 위젯이 처리하므로 여기서는 생략하거나
      // 특정 기본 이미지를 설정하는 로직을 추가할 수 있습니다.
      // widget.onImageChanged(null); // 이미지를 초기화하거나, 특정 기본 이미지 파일 로드
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.isLoginMode,
      maintainState: false,
      maintainAnimation: false,
      maintainSize: false,
      child: Column(
        children: [
          AuthConfirmPasswordInputField(
            controller: widget.confirmPasswordController,
            mainPasswordController: widget.mainPasswordController,
            initialObscureText: true,
          ),
          const SizedBox(height: 16),
          AuthNicknameInputField(
            controller: widget.nicknameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '닉네임을 입력해주세요.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AuthGenderDropdownField(
            selectedGender: widget.selectedGender,
            onChanged: widget.onChangedGender,
          ),
          const SizedBox(height: 16),
          AuthBirthYearDropdownField(
            selectedBirthYear: widget.selectedBirthYear,
            minYear: widget.minYear,
            maxYear: widget.maxYear,
            onChanged: widget.onChangedBirthYear,
          ),
          const SizedBox(height: 16),
          AgeGroupDropdownField(
            selectedValue: widget.selectedMinInterestAge,
            onChanged: widget.onChangedMinInterestAge,
            ageGroupsToDisplay: widget.authProvider.minAgeGroupOptions,
            type: 'min',
            labelText: '최소 관심 연령대',
          ),
          const SizedBox(height: 16),
          AgeGroupDropdownField(
            selectedValue: widget.selectedMaxInterestAge,
            onChanged: widget.onChangedMaxInterestAge,
            ageGroupsToDisplay: widget.authProvider.maxAgeGroupOptions,
            type: 'max',
            labelText: '최대 관심 연령대',
          ),
          const SizedBox(height: 16),
          RegionDropdownField(
            selectedRegion: widget.selectedRegion,
            onChanged: widget.onChangedRegion,
            regions: widget.regions,
            labelText: '거주 지역',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.bioController,
            decoration: InputDecoration(
              labelText: '소개 (선택 사항)',
              hintText: '최대 100자',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 100,
          ),
          const SizedBox(height: 16),
          ProfileImageUploader(
            onImageChanged: widget.onImageChanged,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fillSignUpFieldsWithRandomData,
            child: const Text('랜덤 데이터 채우기'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}