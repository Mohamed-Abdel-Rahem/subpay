import 'package:flutter/material.dart';

class GoogleAuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text; // خليته مرن عشان لو حبيت تغير النص (Login vs Register)

  const GoogleAuthButton({
    super.key,
    required this.onPressed,
    this.text = 'Google', // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      onPressed: onPressed,
      icon: Image.asset('assets/icons/google_icon.png', height: 24),
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
