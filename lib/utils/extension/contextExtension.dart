import 'package:flutter/material.dart';

extension Contextextension on BuildContext {
  void showSnack({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff3A5A98),
        content: Text(
          message,
          style: const TextStyle(color: Color.fromARGB(255, 215, 218, 224)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
