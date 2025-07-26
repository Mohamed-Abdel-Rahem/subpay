import 'package:flutter/material.dart';
import 'package:subpay/auth/screens/registerScreen.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';
import 'package:subpay/auth/widgets/customTextButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    child: CustomTextButton(
                      text: 'نسيت كلمة المرور؟',
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              CustomButton(text: 'تسجيل الدخول'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.16),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                      ),
                      child: CustomText(
                        text: 'أو تسجيل الدخول عن طريق',
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle Google sign-in
                },
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/icons/google_icon.png'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'ليس لديك حساب؟',
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                  CustomTextButton(
                    text: 'انشاء حساب',
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
