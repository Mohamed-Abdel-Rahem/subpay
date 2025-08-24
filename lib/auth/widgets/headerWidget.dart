import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onAddPressed;

  const HeaderWidget({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person_pin, size: screenWidth * 0.08),
          Text(
            'Your rooms',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: screenWidth * 0.08),
            onPressed: onAddPressed,
          ),
        ],
      ),
    );
  }
}
