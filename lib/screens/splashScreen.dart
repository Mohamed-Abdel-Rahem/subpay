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

    // بعد 4 ثواني، انتقل إلى الصفحة التالية
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, HomePage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff140165), // لون الخلفية
      body: Center(
        child: CustomText(
          text: 'SubPay',
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
