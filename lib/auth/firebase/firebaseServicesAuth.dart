import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subpay/core/users/enterCodeRoom.dart';
import 'package:subpay/core/screens/mainScreenAdmin.dart';
import 'package:subpay/utils/extension/contextExtension.dart';
import 'package:firebase_database/firebase_database.dart'; // تأكد من هذا الاستيراد

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates a new user account with email & password
  /// Then sends email verification and saves user to Firestore
  static Future<void> createAccount({
    required String username,
    required String email,
    required String password,
    required String phone,
    required BuildContext context,
    required bool isLoading,
  }) async {
    try {
      // Create user with email and password
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await credential.user!.sendEmailVerification();

      String uid = credential.user!.uid;
      // Add user data to Firestore
      await addUserToFirestore(
        uid: uid,
        email: email,
        phone: phone,
        username: username,
      );
      // Inform user to check email
      context.showSnack(
        message:
            'تم إنشاء الحساب. يُرجى تفعيل البريد الإلكتروني قبل تسجيل الدخول.',
      );

      await _auth.signOut();
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

  /// Adds user information to Firestore
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

  static Future<UserCredential?> loginUsers({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ شرط الأدمن: البريد ينتهي بـ @subpay.com
      if (email.endsWith('@subpay.com')) {
        final adminsRef = FirebaseDatabase.instance.ref('admins');
        final adminsSnapshot = await adminsRef.get();

        if (adminsSnapshot.exists) {
          final admins = adminsSnapshot.value as Map;

          final isAdmin = admins.values.contains(email);

          if (isAdmin) {
            Navigator.pushNamed(context, MainScreenAdmin.id);
            return credential;
          }
        }
      }

      // ✅ مستخدم عادي
      await credential.user!.reload();
      final refreshedUser = _auth.currentUser;

      if (!refreshedUser!.emailVerified) {
        context.showSnack(
          message: 'يرجى تفعيل البريد الإلكتروني قبل تسجيل الدخول.',
        );
        return credential;
      }

      Navigator.pushNamed(context, EnterCodeRoom.id);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnack(message: 'لا يوجد مستخدم بهذا البريد.');
      } else if (e.code == 'wrong-password') {
        context.showSnack(message: 'كلمة المرور غير صحيحة.');
      } else {
        context.showSnack(message: 'فشل تسجيل الدخول: ${e.message}');
      }
      return null;
    } catch (e) {
      context.showSnack(message: 'حدث خطأ غير متوقع: ${e.toString()}');
      return null;
    }
  }

  /// Resends email verification if the user is not verified
  static Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      await user?.reload(); // مهم جداً لتحديث الحالة

      user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        context.showSnack(message: 'تم إرسال رابط التفعيل مجددًا إلى بريدك.');
      } else {
        context.showSnack(message: 'البريد مفعل بالفعل أو لا يوجد مستخدم.');
      }
    } catch (e) {
      context.showSnack(message: 'فشل في إرسال رابط التفعيل: ${e.toString()}');
    }
  }

  static Future<void> resendResetPasswordEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      context.showSnack(
        message: 'تم إرسال رابط جديد لإعادة تعيين كلمة المرور.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnack(message: 'لا يوجد مستخدم بهذا البريد.');
      } else {
        context.showSnack(message: 'فشل إرسال الرابط: ${e.message}');
      }
    } catch (e) {
      context.showSnack(message: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  static Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut(); // يجبر اختيار الإيميل
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        context.showSnack(message: 'تم إلغاء تسجيل الدخول.');
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      final isNew = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNew) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
              'username': user.displayName ?? '',
              'email': user.email ?? '',
              'profile_image': user.photoURL ?? '',
              'phone': '',
            });

        context.showSnack(message: 'تم إنشاء الحساب بنجاح ✨');
      } else {
        context.showSnack(message: 'تم تسجيل الدخول باستخدام Google.');
      }

      return true;
    } on FirebaseAuthException catch (e) {
      context.showSnack(message: 'خطأ في تسجيل الدخول بـ Google: ${e.message}');
      return false;
    } catch (e) {
      context.showSnack(message: 'فشل تسجيل الدخول بـ Google: ${e.toString()}');
      return false;
    }
  }
}
