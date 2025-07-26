import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/auth/firebase/firebaseServicesAuth.dart';
import 'package:subpay/auth/screens/loginScreen.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';
import 'package:subpay/auth/widgets/customTextButton.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;
  String? email, password, username, phone;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        body: Form(
          key: formKey,
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

                  // Username Field
                  CustomInputField(
                    label: 'اسم المستخدم',
                    hint: 'ادخل اسم المستخدم',
                    onChanged: (value) => username = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'اسم المستخدم مطلوب';
                      }
                      return null;
                    },
                  ),

                  // Phone Field
                  CustomInputField(
                    label: 'رقم الهاتف',
                    hint: 'ادخل رقم الهاتف',
                    onChanged: (value) => phone = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                  ),

                  // Email Field
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

                  // Password Field
                  CustomInputField(
                    label: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور',
                    isPassword: true,
                    onChanged: (value) => password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمة المرور مطلوبة';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  // الشروط والأحكام
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        activeColor: Colors.blue,
                        onChanged: (newBool) {
                          setState(() {
                            isChecked = newBool!;
                          });
                        },
                      ),
                      CustomText(
                        color: const Color(0xff6A8DC1),
                        text: 'أوافق على الشروط والأحكام ',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),

                  // زر إنشاء الحساب
                  CustomButton(
                    text: 'انشاء حساب',
                    onPressed: () async {
                      if (!isChecked) {
                        context.showSnack(
                          message:
                              'يجب عليك الموافقة على الشروط والأحكام للمتابعة.',
                        );
                        return;
                      }

                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);

                        await FirebaseServices.createAccount(
                          email: email!,
                          password: password!,
                          context: context,
                          isLoading: isLoading,
                          username: username!,
                          phone: phone!,
                        );

                        setState(() => isLoading = false);
                      }
                    },
                  ),

                  // أو تسجيل عبر Google
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.16,
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.grey)),
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
                        const Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      // Google sign-in هنا
                    },
                    icon: Image.asset('assets/icons/google_icon.png'),
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
