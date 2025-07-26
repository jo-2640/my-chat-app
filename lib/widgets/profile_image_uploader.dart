//lib/widgets/profile_image_uploader.dart
import 'dart:io'; // FileImage를 위해 필요
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // XFile 타입 선언을 위해 필요
import 'package:fist_app/utils/app_logger.dart'; // 로깅을 위해 필요
import 'package:fist_app/utils/utils.dart'; // showToast 함수를 위해 임포트

class ProfileImageUploader extends StatefulWidget {
  // 이 콜백은 이미지가 변경(선택/촬영/취소)될 때마다 부모에게 변경된 File?을 전달합니다.
  final ValueChanged<File?> onImageChanged; // <--- XFile? 대신 File?로 변경

  const ProfileImageUploader({
    super.key,
    required this.onImageChanged, // 부모에게 변경된 이미지 상태를 알리는 콜백
  });

  @override
  State<ProfileImageUploader> createState() => _ProfileImageUploaderState();
}

class _ProfileImageUploaderState extends State<ProfileImageUploader> {
  // ✨ 위젯 내부에서 관리하는 선택된 이미지 파일 상태 (이제 File?로 저장)
  File? _pickedImage; // <--- XFile? 대신 File?로 변경
  final ImagePicker _picker = ImagePicker(); // ImagePicker 인스턴스

  // 갤러리에서 이미지 선택 함수
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path); // <--- XFile을 File로 변환
        setState(() {
          _pickedImage = file; // <--- 변환된 File 객체를 저장
        });
        widget.onImageChanged(_pickedImage); // ✨ 부모에게 변경된 File? 전달
        appLogger.d('갤러리에서 이미지 선택 완료: ${image.path}');
      } else {
        appLogger.d('이미지 선택 취소됨.');
        widget.onImageChanged(null); // 취소 시 부모에게 null 전달
      }
    } catch (e) {
      appLogger.e('이미지 선택 오류: $e');
      widget.onImageChanged(null); // 오류 시 부모에게 null 전달
    }
  }

  // 사진 촬영 함수
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final File file = File(photo.path); // <--- XFile을 File로 변환
        setState(() {
          _pickedImage = file; // <--- 변환된 File 객체를 저장
        });
        widget.onImageChanged(_pickedImage); // ✨ 부모에게 변경된 File? 전달
        appLogger.d('사진 촬영 완료: ${photo.path}');
      } else {
        appLogger.d('사진 촬영 취소됨.');
        widget.onImageChanged(null); // 취소 시 부모에게 null 전달
      }
    } catch (e) {
      appLogger.e('사진 촬영 오류: $e');
      widget.onImageChanged(null); // 오류 시 부모에게 null 전달
    }
  }

  // 이미지 선택 취소 함수
  void _clearImage() {
    setState(() {
      _pickedImage = null; // 이미지 선택 취소
    });
    widget.onImageChanged(_pickedImage); // ✨ 부모에게 변경된 이미지 전달 (null)
    if (context.mounted) {
      showToast(context, '이미지 선택이 취소되었습니다.', 'info');
    }
    appLogger.d('이미지 선택 취소됨.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 프로필 이미지 미리보기
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: _pickedImage != null
                  ? FileImage(_pickedImage!) // _pickedImage가 이미 File이므로 바로 사용
                  : null,
              child: _pickedImage == null
                  ? Image.asset(
                'assets/img/default_profile_guest.png',
                fit: BoxFit.cover,
              )
                  : null,
            ),
            const SizedBox(width: 16),

            // 2. 이미지 선택/촬영 버튼
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage, // ✨ 위젯 내부 함수 연결
                    icon: const Icon(Icons.image),
                    label: const Text('갤러리에서 선택'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _takePhoto, // ✨ 위젯 내부 함수 연결
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('사진 촬영'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. 선택된 파일 이름 표시 및 선택 취소 버튼
        if (_pickedImage != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                '선택된 파일: ${_pickedImage!.path.split('/').last}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
          ),
        if (_pickedImage != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: _clearImage, // ✨ 위젯 내부 함수 연결
              child: const Text('선택 취소'),
            ),
          ),
      ],
    );
  }
}
