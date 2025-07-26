import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.onPressed});
  final String text;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.033,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff140165),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .35,
            vertical: screenHeight * 0.017,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
