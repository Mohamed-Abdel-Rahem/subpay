import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              CustomInputField(
                label: 'البريد الالكتروني',
                hint: 'ادخل البريد الالكتروني',
              ),
              CustomInputField(
                label: 'كلمة المرور',
                hint: 'ادخل كلمة المرور',
                isPassword: true,
              ),
              CustomButton(text: 'تسجيل الدخول'),
            ],
          ),
        ),
      ),
    );
  }
}
