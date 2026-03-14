import 'package:flutter/material.dart';

Widget buildSocialDivider({required String text}) {
  return Row(
    children: [
      Expanded(child: Divider(color: Colors.grey[300])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          text,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ),
      Expanded(child: Divider(color: Colors.grey[300])),
    ],
  );
}
