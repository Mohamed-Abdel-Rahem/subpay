import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:subpay/model/app_user.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class FirestoreService {
  // Singleton Pattern
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// إضافة بيانات مستخدم جديد إلى Firestore
  Future<void> addDataToFirestore({
    required AppUser userAccount,
    required BuildContext context,
  }) async {
    try {
      final String? uid = _auth.currentUser?.uid;

      if (uid != null) {
        userAccount.uId = uid;

        await _firestore.collection('users').doc(uid).set(userAccount.toMap());

        print("تم بنجاح: إضافة بيانات المستخدم إلى Firestore للمعرف: $uid");
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'حدث خطأ في قاعدة البيانات: ${e.message}',
          color: Colors.red,
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'عذراً، حدث خطأ غير متوقع أثناء حفظ البيانات.',
          color: Colors.red,
        );
      }
    }
  }

  /// جلب بيانات المستخدم الحالي من Firestore وتحويلها لـ Model
  Future<AppUser?> readDataFromFirestore({
    required BuildContext context,
  }) async {
    try {
      final String? uid = _auth.currentUser?.uid;

      if (uid == null) {
        print("خطأ: لم يتم العثور على مستخدم مسجل دخول.");
        return null;
      }

      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        print('تم بنجاح: جلب بيانات المستخدم: ${doc.data()}');
        return AppUser.fromMap(doc.data()!);
      } else {
        print("تنبيه: لا يوجد مستند لهذا المستخدم بالمعرف: $uid");
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'فشل في جلب بياناتك: ${e.message}',
          color: Colors.red,
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          message: 'حدث خطأ أثناء قراءة البيانات، يرجى المحاولة لاحقاً.',
          color: Colors.red,
        );
      }
    }
    return null;
  }
}
