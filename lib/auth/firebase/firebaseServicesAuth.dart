// ignore_for_file: unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/auth/screens/homePage.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class FirebaseServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1- Create A new Account
  static Future<void> createAccount({
    required String username,
    required String email,
    required String password,
    required BuildContext context,
    required bool isLoading,
    required String groupValue,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = credential.user!.email!; // Use email as UID
      await addUserToFirestore(
        uid: uid,
        email: email,
        groupValue: groupValue,
        username: username,
      );
      context.showSnack(message: 'Registration Done...');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        isLoading = false;
        context.showSnack(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        isLoading = false;
        context.showSnack(
          message: 'The account already exists for this email.',
        );
      }
    } catch (e) {
      isLoading = false;
      context.showSnack(message: 'There was an error');
    }
  }

  // 2- Add Data in firestore
  static Future<void> addUserToFirestore({
    required String uid,
    required String username,
    required String email,
    required String groupValue,
    String? profile_image,
  }) async {
    // Add user data to Firestore using the email as the document ID (UID)
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'username': username,
      'gender': groupValue,
      'profile_image': profile_image,
    });
    await FirebaseAuth.instance.signOut();
  }

  // 3- Login User
  static Future<void> loginUsers({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, HomePage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showSnack(message: 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        context.showSnack(message: 'Wrong password provided for that user.');
      }
    }
  }

  //6-  Change Password
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Reauthenticate the user with their current credentials
        final credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: currentPassword,
        );
        await currentUser.reauthenticateWithCredential(credential);

        // Update password
        await currentUser.updatePassword(newPassword);
      } else {
        throw Exception("No user is currently signed in.");
      }
    } catch (e) {
      rethrow; // Propagate the exception for handling
    }
  }
}
