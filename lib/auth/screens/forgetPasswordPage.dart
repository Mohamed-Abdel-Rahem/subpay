import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/auth/firebase/firebaseServicesAuth.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  static String id = 'ForgetPassword';

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? email;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'تغير كلمة المرور',
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset('assets/icons/arrow_back.png'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  CustomText(
                    text: 'ادخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 104, 103, 103),
                  ),
                  SizedBox(height: screenHeight * 0.04),
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseServices.resendResetPasswordEmail(
                              context: context,
                              email: email!,
                            );
                            setState(() {
                              isLoading = false;
                            });
                          }
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
                                ' إرسال بريد التحقق',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
