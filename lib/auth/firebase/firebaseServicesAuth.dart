// ✅ Updated FirebaseServices with correct UID and error handling
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/auth/screens/homePage.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<void> createAccount({
    required String username,
    required String email,
    required String password,
    required String phone,
    required BuildContext context,
    required bool isLoading,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid; // ✅ Use UID instead of email

      await addUserToFirestore(
        uid: uid,
        email: email,
        phone: phone,
        username: username,
      );

      context.showSnack(message: 'تم إنشاء الحساب بنجاح.');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        context.showSnack(message: 'كلمة المرور ضعيفة جداً.');
      } else if (e.code == 'email-already-in-use') {
        context.showSnack(message: 'هذا البريد مستخدم بالفعل.');
      } else {
        context.showSnack(message: 'خطأ أثناء إنشاء الحساب: ${e.message}');
      }
    } catch (e) {
      context.showSnack(message: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  static Future<void> addUserToFirestore({
    required String uid,
    required String username,
    required String email,
    required String phone,
    String? profileImage,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'profile_image': profileImage ?? '',
      });
    } catch (e) {
      print('Firestore Error: $e');
      rethrow;
    }
  }

  static Future<void> loginUsers({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, HomePage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnack(message: 'لا يوجد مستخدم بهذا البريد.');
      } else if (e.code == 'wrong-password') {
        context.showSnack(message: 'كلمة المرور غير صحيحة.');
      } else {
        context.showSnack(message: 'فشل تسجيل الدخول: ${e.message}');
      }
    }
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser != null) {
        final credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: currentPassword,
        );

        await currentUser.reauthenticateWithCredential(credential);
        await currentUser.updatePassword(newPassword);
      } else {
        throw Exception("لم يتم تسجيل دخول أي مستخدم.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
