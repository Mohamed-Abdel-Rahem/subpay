import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/customText.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: () {},
      child: CustomText(
        text: text,
        fontSize: screenWidth * .03,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
      ),
    );
  }
}
