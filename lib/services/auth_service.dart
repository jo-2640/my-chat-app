// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth 사용을 위해
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 사용을 위해
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 사용을 위해
import 'package:flutter/material.dart'; // BuildContext, showToast 등을 위해
import 'package:fist_app/utils/app_logger.dart'; // 로거 사용을 위해
import 'dart:io';

class AuthService {
  // Firebase 서비스 인스턴스들을 static으로 선언하여 어디서든 접근 가능하게 합니다.
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;

  // Firebase 인증 상태 변경 리스너 설정
  // 이 함수는 앱 시작 시 main.dart에서 호출됩니다.
  static void setupAuthListener() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        appLogger.i('인증 상태 변경: 사용자 로그인됨 (UID: ${user.uid})');
        // TODO: 로그인된 사용자를 위한 UI 업데이트 (예: 메인 화면으로 이동)
      } else {
        appLogger.i('인증 상태 변경: 사용자 로그아웃됨');
        // TODO: 로그아웃된 사용자를 위한 UI 업데이트 (예: 로그인 화면으로 이동)
      }
    });
  }

  // 로그인 처리 함수
  static Future<String?> handleLogin(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // 로그인 성공, 에러 메시지 없음
    } on FirebaseAuthException catch (e) {
      // 특정 Firebase 인증 오류 처리
      if (e.code == 'user-not-found') {
        return '사용자를 찾을 수 없습니다.';
      } else if (e.code == 'wrong-password') {
        return '잘못된 비밀번호입니다.';
      }
      return e.message; // Firebase의 일반 에러 메시지 반환
    } catch (e) {
      // 기타 예상치 못한 에러 처리
      return '로그인 중 알 수 없는 오류가 발생했습니다.';
    }
  }

  // 회원가입 처리 함수
  static Future<String?> handleSignup({
    required String email,
    required String password,
    required String nickname,
    required String bio,
    required String birthYear,
    required String region,
    required File profileImage, // 프로필 이미지 파일
    required String gender,
    required String minInterestAge,
    required String maxInterestAge,
  })async {
    appLogger.i('회원가입 처리 시작: $email, $nickname');
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 사용자 생성 직후 닉네임(표시 이름) 업데이트
      await userCredential.user?.updateDisplayName(nickname);
      // TODO: Firebase Firestore에 더 많은 사용자 데이터를 저장할 계획이라면 이 부분에서 수행하세요.
      // 예: await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({'nickname': nickname});
      return null; // 회원가입 성공, 에러 메시지 없음
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return '비밀번호가 너무 취약합니다.';
      } else if (e.code == 'email-already-in-use') {
        return '이미 사용 중인 이메일입니다.';
      }
      return e.message; // Firebase의 일반 에러 메시지 반환
    } catch (e) {
      return '회원가입 중 알 수 없는 오류가 발생했습니다.';
    }
  }

  // 로그아웃 처리 함수
  // 로그아웃: 이 함수는 값을 반환하지 않으므로 void로 유지됩니다.
  static Future<void> handleLogout(BuildContext context) async {
    await auth.signOut();
    // TODO: 로그아웃 후 사용자를 AuthScreen으로 다시 이동시키고 싶을 것입니다.
    // if (context.mounted) Navigator.of(context).pushReplacement(...);
  }


}


// TODO: currentUserUid, currentUserData, currentUserNickname 등은
// FirebaseAuth.instance.currentUser를 통해 접근하거나
// Firestore에서 사용자 데이터를 읽어와 관리하는 로직을 추가할 수 있습니다.
// 예: static User? get currentUser => auth.currentUser;
