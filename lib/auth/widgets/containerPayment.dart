import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/customText.dart';

class ContainerPayment extends StatelessWidget {
  const ContainerPayment({
    super.key,
    required this.onPressed,
    required this.imagePath,
    required this.text,
  });
  final VoidCallback onPressed;
  final String imagePath;
  final String text;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.only(left: screenWidth * 0.04),
          width: double.infinity,
          height: screenWidth * 0.18,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 38, 18, 129),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: screenWidth * 0.25,
                height: screenHeight * 0.12,
              ),
              CustomText(
                text: text,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: screenWidth * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
