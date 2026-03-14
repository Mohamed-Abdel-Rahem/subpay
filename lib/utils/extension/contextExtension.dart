import 'package:flutter/material.dart';

extension SnakBarExtension on BuildContext {
  void showSnackBar({
    required String message,
    Color color = const Color(0xff140165),
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: color,
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
