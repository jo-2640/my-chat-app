import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImageUtils {
  // showToast 함수가 이 클래스 외부에서 정의되었다면,
  // 이 클래스의 메서드들이 showToast를 직접 호출하는 대신,
  // showToast를 인자로 받거나, 콜백으로 처리하는 방식을 고려할 수 있습니다.
  // 여기서는 편의상 직접 호출한다고 가정합니다.

  static Future<File?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);


    if (image != null) {
        return File(image.path);
    } else {

      return null;
    }
  }

  static Future<File?> takePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (image != null) {

      return File(image.path);
    } else {

      return null;
    }
  }
}