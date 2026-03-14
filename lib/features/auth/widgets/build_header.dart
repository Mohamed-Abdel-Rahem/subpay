import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customText.dart';

Widget buildHeader({
  required String text,
  required String subText,
  required IconData icon,
}) {
  return Column(
    children: [
      Icon(
      icon ,
        size: 70,
        color: Colors.blueAccent,
      ),
      const SizedBox(height: 16),
      CustomText(
        text: text,
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      const SizedBox(height: 8),
      CustomText(
        text: subText,
        fontSize: 14,
        color: Colors.grey[600]!,
        fontWeight: FontWeight.bold,
      ),
    ],
  );
}
