import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:subpay/services/firestore_service.dart';
import 'package:subpay/features/core/payment/choosePaymentMethod.dart';
import 'package:subpay/model/app_user.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

const int _maxRetries = 20;

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  Timer? _timer;
  int _retryCount = 0;

  /// Registers a new user and handles initial setup
  Future<void> createAccount({
    required BuildContext context,
    required AppUser userAccount,
  }) async {
    try {
      // Attempt to create user in Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: userAccount.email,
            password: userAccount.password,
          );

      User? user = userCredential.user;

      if (user != null) {
        // Trigger verification email
        await user.sendEmailVerification();

        // Save user profile data to Firestore
        await FirestoreService.instance.addDataToFirestore(
          userAccount: userAccount,
          context: context,
        );

        if (context.mounted) {
          context.showSnackBar(
            message:
                'تم إنشاء الحساب بنجاح! يرجى مراجعة بريدك الإلكتروني لتفعيله.',
          );
        }

        // Start monitoring for email verification status
        _startEmailVerificationTimer(context, userAccount);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String errorMessage = 'حدث خطأ أثناء التسجيل';

        // Mapping Firebase error codes to user-friendly Arabic messages
        if (e.code == 'weak-password') {
          errorMessage = 'كلمة المرور ضعيفة جداً.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'هذا البريد الإلكتروني مستخدم بالفعل.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'صيغة البريد الإلكتروني غير صحيحة.';
        }

        context.showSnackBar(message: errorMessage, color: Colors.red);
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'حدث خطأ غير متوقع، حاول مرة أخرى.',
          color: Colors.red,
        );
      }
    }
  }

  /// Periodically checks if the user has verified their email
  void _startEmailVerificationTimer(BuildContext context, AppUser userAccount) {
    _timer?.cancel();
    _retryCount = 0;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      _retryCount++;

      // Stop polling after reaching max retries (timeout)
      if (_retryCount >= _maxRetries) {
        timer.cancel();
        _timer = null;
        if (context.mounted) {
          context.showSnackBar(
            message:
                'انتهت مهلة التأكد. يرجى تفعيل الحساب من بريدك والمحاولة مرة أخرى.',
            color: Colors.orange,
          );
        }
        return;
      }

      // Refresh user state from Firebase server
      await _auth.currentUser?.reload();
      User? user = _auth.currentUser;

      // Handle successful verification
      if (user != null && user.emailVerified) {
        timer.cancel();
        _timer = null;

        if (context.mounted) {
          context.showSnackBar(
            message: 'تم تفعيل البريد بنجاح! يمكنك الآن تسجيل الدخول.',
          );
        }
      }
    });
  }

  /// Authenticates a user with email and password
  Future<void> logInUser({
    required AppUser userAccount,
    required BuildContext context,
  }) async {
    try {
      UserCredential currentUser = await _auth.signInWithEmailAndPassword(
        email: userAccount.email,
        password: userAccount.password,
      );

      final User? user = currentUser.user;

      if (user != null) {
        if (user.emailVerified) {
          // Success case: Navigate to next screen
          Navigator.pushNamed(context, '/choosePaymentMethod');
        } else {
          // Case where email is not verified yet
          await _auth.signOut();
          if (context.mounted) {
            context.showSnackBar(
              message: 'يرجى تفعيل بريدك الإلكتروني أولاً قبل تسجيل الدخول!',
              color: Colors.orange,
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';

        // Mapping Login-specific Firebase error codes to Arabic
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'تم تعطيل هذا الحساب.';
        }

        context.showSnackBar(message: errorMessage, color: Colors.red);
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.',
          color: Colors.red,
        );
      }
    }
  }

  /// Clean up resources to prevent memory leaks
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    try {
      await _googleSignIn.signOut();
      // 1. Trigger the Google account selection UI
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User cancelled

      // 2. Get the authentication tokens from Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the Google credential
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      // 5. Check if the user is new and handle Firestore entry
      if (user != null && context.mounted) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // 6. Create profile ONLY if the user is new
          AppUser newUser = AppUser(
            uId: user.uid, // Don't forget the UID
            email: user.email ?? '',
            password: '', // Google users don't have passwords
            name: user.displayName ?? '',
          );

          await FirestoreService.instance.addDataToFirestore(
            userAccount: newUser,
            context: context,
          );
          print("مستخدم جديد: تم إنشاء حساب وحفظ البيانات");
        } else {
          print("مستخدم قديم: تم تسجيل الدخول بنجاح");
        }

        // 7. Success: Navigate to the next screen (for both new and old users)
        if (context.mounted) {
          Navigator.pushNamed(context, ChoosePaymentMethod.id);
        }
      }
    } catch (e) {
      print("Google Auth Error: $e");
      if (context.mounted) {
        context.showSnackBar(
          message:
              'عذراً، فشل تسجيل الدخول باستخدام جوجل. يرجى المحاولة لاحقاً.',
          color: Colors.red,
        );
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      if (context.mounted) {
        context.showSnackBar(message: 'تم تسجيل الخروج بنجاح.');
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'فشل تسجيل الخروج: ${e.message}',
          color: Colors.red,
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'حدث خطأ غير متوقع أثناء تسجيل الخروج.',
          color: Colors.red,
        );
      }
    }
  }
}
/* Future<void> _handleGoogleSignIn() async {
    setState(() => isLoading = true);
    bool success = await AuthService.signInWithGoogle(context);
    if (mounted) setState(() => isLoading = false);
    if (success) {
      Navigator.pushNamed(context, HomePage.id);
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
        context.showSnackBar(
          message: 'يرجى تفعيل البريد الإلكتروني قبل تسجيل الدخول.',
        );
        return credential;
      }

      Navigator.pushNamed(context, ChoosePaymentMethod.id);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnackBar(message: 'لا يوجد مستخدم بهذا البريد.');
      } else if (e.code == 'wrong-password') {
        context.showSnackBar(message: 'كلمة المرور غير صحيحة.');
      } else {
        context.showSnackBar(message: 'فشل تسجيل الدخول: ${e.message}');
      }
      return null;
    } catch (e) {
      context.showSnackBar(message: 'حدث خطأ غير متوقع: ${e.toString()}');
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

        context.showSnackBar(
          message: 'تم إرسال رابط التفعيل مجددًا إلى بريدك.',
        );
      } else {
        context.showSnackBar(message: 'البريد مفعل بالفعل أو لا يوجد مستخدم.');
      }
    } catch (e) {
      context.showSnackBar(
        message: 'فشل في إرسال رابط التفعيل: ${e.toString()}',
      );
    }
  }

  static Future<void> resendResetPasswordEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      context.showSnackBar(
        message: 'تم إرسال رابط جديد لإعادة تعيين كلمة المرور.',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnackBar(message: 'لا يوجد مستخدم بهذا البريد.');
      } else {
        context.showSnackBar(message: 'فشل إرسال الرابط: ${e.message}');
      }
    } catch (e) {
      context.showSnackBar(message: 'حدث خطأ غير متوقع: ${e.toString()}');
    }
  }

  static Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut(); // يجبر اختيار الإيميل
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        context.showSnackBar(message: 'تم إلغاء تسجيل الدخول.');
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

        context.showSnackBar(message: 'تم إنشاء الحساب بنجاح ✨');
      } else {
        context.showSnackBar(message: 'تم تسجيل الدخول باستخدام Google.');
      }

      return true;
    } on FirebaseAuthException catch (e) {
      context.showSnackBar(
        message: 'خطأ في تسجيل الدخول بـ Google: ${e.message}',
      );
      return false;
    } catch (e) {
      context.showSnackBar(
        message: 'فشل تسجيل الدخول بـ Google: ${e.toString()}',
      );
      return false;
    }
  }
  }*/