import 'package:flutter/material.dart';

extension Contextextension on BuildContext {
  void showSnack({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xff140165),
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Color.fromARGB(255, 215, 218, 224),
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
