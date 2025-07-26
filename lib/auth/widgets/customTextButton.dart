import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/customText.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
  });
  final String text;
  final Color color;
  final Function? onPressed;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: onPressed as void Function()?,
      child: CustomText(
        text: text,
        fontSize: screenWidth * .03,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
