// lib/widgets/signup_form_fields.dart
import 'package:flutter/material.dart';
import 'package:fist_app/widgets/auth_confirm_password_input_field.dart';
import 'package:fist_app/widgets/auth_nickname_input_field.dart';
import 'package:fist_app/widgets/auth_gender_dropdown_field.dart';
import 'package:fist_app/widgets/auth_birth_year_dropdown_field.dart';
import 'package:fist_app/widgets/age_group_dropdown_field.dart';
import 'package:fist_app/widgets/region_dropdown_field.dart';
import 'package:fist_app/widgets/profile_image_uploader.dart';
import 'dart:io';
// appLogger 임포트 (필요하다면)
// import 'package:your_app_name/utils/app_logger.dart'; // 예시

class SignUpFormFields extends StatelessWidget {
  final bool isLoginMode; // <<-- 이 위젯이 모드를 받아서 내부에서 처리
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
  final void  Function(File?) onImageChanged; // File 타입이 될 수 있으므로 dynamic으로 임시 처리

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
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isLoginMode, // 로그인 모드가 아닐 때만 이 모든 필드들을 보이도록
      maintainState: false, // 숨겨질 때 상태를 유지할지 여부
      maintainAnimation: false,
      maintainSize: false,
      child: Column( // 이 모든 필드들을 세로로 나열
        children: [
          // AuthConfirmPasswordInputField (이제 이 위젯 내부는 isLoginMode를 직접 받을 필요 없습니다)
          AuthConfirmPasswordInputField(
            controller: confirmPasswordController,
            mainPasswordController: mainPasswordController,
            initialObscureText: true,
          ),
          const SizedBox(height: 16),
          AuthNicknameInputField(
            controller: nicknameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '닉네임을 입력해주세요.';
              }
              return null;
            },
            isLoginMode: false, // 마찬가지로 isLoginMode를 false로 고정하거나 제거
          ),
          const SizedBox(height: 16),
          AuthGenderDropdownField(
            selectedGender: selectedGender,
            onChanged: onChangedGender,
          ),
          const SizedBox(height: 16),
          AuthBirthYearDropdownField(
            selectedBirthYear: selectedBirthYear,
            minYear: minYear,
            maxYear: maxYear,
            onChanged: onChangedBirthYear,
          ),
          const SizedBox(height: 16),
          AgeGroupDropdownField(
            selectedValue: selectedMinInterestAge,
            onChanged: onChangedMinInterestAge,
            type: 'min',
            labelText: '최소 관심 연령대',
          ),
          const SizedBox(height: 16),
          AgeGroupDropdownField(
            selectedValue: selectedMaxInterestAge,
            onChanged: onChangedMaxInterestAge,
            type: 'max',
            labelText: '최대 관심 연령대',
          ),
          const SizedBox(height: 16),
          RegionDropdownField(
            selectedRegion: selectedRegion,
            onChanged: onChangedRegion,
            regions: regions,
            labelText: '거주 지역',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: bioController,
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
            onImageChanged: onImageChanged,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}