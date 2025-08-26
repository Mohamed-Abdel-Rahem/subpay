import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/auth/firebase/firebaseServicesAuth.dart';
import 'package:subpay/auth/screens/forgetPasswordPage.dart';
import 'package:subpay/auth/screens/registerScreen.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';
import 'package:subpay/auth/widgets/customTextButton.dart';
import 'package:subpay/core/users/enterCodeRoom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool showResendButton = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                    text: 'تسجيل الدخول',
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // البريد الإلكتروني
                  CustomInputField(
                    label: 'البريد الالكتروني',
                    hint: 'ادخل البريد الالكتروني',
                    onChanged: (value) => email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'البريد الالكتروني مطلوب';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'صيغة البريد غير صحيحة';
                      }
                      return null;
                    },
                  ),

                  // كلمة المرور
                  CustomInputField(
                    label: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور',
                    isPassword: true,
                    onChanged: (value) => password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمة المرور مطلوبة';
                      }
                      return null;
                    },
                  ),

                  // نسيت كلمة المرور
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: CustomTextButton(
                          text: 'نسيت كلمة المرور؟',
                          color: Colors.grey,
                          onPressed: () {
                            Navigator.pushNamed(context, ForgetPassword.id);
                          },
                        ),
                      ),
                    ],
                  ),

                  // زر تسجيل الدخول
                  CustomButton(
                    text: 'تسجيل الدخول',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          showResendButton = false;
                        });

                        final userCredential =
                            await FirebaseServices.loginUsers(
                              email: email!,
                              password: password!,
                              context: context,
                            );

                        setState(() => isLoading = false);

                        if (userCredential != null &&
                            !userCredential.user!.emailVerified) {
                          setState(() => showResendButton = true);
                        }
                      }
                    },
                  ),

                  if (showResendButton && !email!.endsWith('@subpay.com'))
                    AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await FirebaseServices.resendVerificationEmail(
                              context,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(
                                    77,
                                    33,
                                    150,
                                    243,
                                  ), // بدل Colors.blueAccent.withOpacity(0.3)
                                  blurRadius: 10,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.1,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.send, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'إعادة إرسال رابط التفعيل',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // تسجيل الدخول عبر Google
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
                            text: 'أو تسجيل الدخول عن طريق',
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

                  IconButton(
                    onPressed: () async {
                      setState(() => isLoading = true);

                      bool success = await FirebaseServices.signInWithGoogle(
                        context,
                      );

                      setState(() => isLoading = false);

                      if (success) {
                        Navigator.pushNamed(context, EnterCodeRoom.id);
                      }
                    },
                    icon: Image.asset('assets/icons/google_icon.png'),
                  ),

                  // رابط التسجيل
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
        ),
      ),
    );
  }
}
