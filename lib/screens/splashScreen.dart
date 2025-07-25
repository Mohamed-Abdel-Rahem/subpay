import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subpay/screens/homePage.dart';
import 'package:subpay/widgets/customText.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, HomePage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;

    return Scaffold(
      backgroundColor: const Color(0xff140165),
      body: Center(
        child: CustomText(
          text: 'SubPay',
          fontSize: screenWidth * 0.1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
