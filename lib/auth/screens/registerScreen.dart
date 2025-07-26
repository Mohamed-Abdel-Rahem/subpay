import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/auth/screens/loginScreen.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';
import 'package:subpay/auth/widgets/customTextButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  CustomText(
                    text: 'انشاء حساب جديد',
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  CustomInputField(
                    label: 'اسم المستخدم',
                    hint: 'ادخل اسم المستخدم',
                  ),
                  CustomInputField(
                    label: 'رقم الهاتف',
                    hint: 'ادخل رقم الهاتف',
                  ),
                  CustomInputField(
                    label: 'البريد الالكتروني',
                    hint: 'ادخل البريد الالكتروني',
                  ),
                  CustomInputField(
                    label: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور',
                    isPassword: true,
                  ),
                  CustomButton(text: 'انشاء حساب '),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                          ),
                          child: CustomText(
                            text: "أو انشاء حساب عن طريق",
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey, thickness: 1),
                        ),
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
                        text: 'هل لديك حساب بالفعل؟',
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      CustomTextButton(
                        text: 'تسجيل الدخول',
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
