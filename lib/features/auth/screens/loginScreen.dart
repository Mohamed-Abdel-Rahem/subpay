import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/features/auth/widgets/build_divder.dart';
import 'package:subpay/features/auth/widgets/build_forgetPassword.dart';
import 'package:subpay/features/auth/widgets/build_header.dart';
import 'package:subpay/features/auth/widgets/build_ink.dart';
import 'package:subpay/features/auth/widgets/build_input_login.dart';
import 'package:subpay/features/auth/widgets/buttons/google_button.dart';
import 'package:subpay/services/firebase_services_auth.dart';
import 'package:subpay/features/auth/screens/forgetPasswordPage.dart';
import 'package:subpay/features/auth/screens/registerScreen.dart';
import 'package:subpay/widgets/buttons/customButton.dart';
import 'package:subpay/model/app_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- State Variables ---
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  String? _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  // --- Main Form Wrapper ---
  Widget _buildLoginForm() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(
              text: 'تسجيل الدخول',
              subText: 'قم بتسجيل الدخول للمتابعة',
              icon: Icons.lock_person_rounded,
            ),
            const SizedBox(height: 40),
            // جوه الـ Column في _buildLoginForm
            LoginInputFields(
              onEmailChanged: (value) => _email = value,
              onPasswordChanged: (value) => _password = value,
              emailValidator: _validateEmail,
            ),
            buildForgotPasswordLink(
              context: context,
              routeName: ForgetPassword.id,
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'تسجيل الدخول', onPressed: _handleLogin),
            const SizedBox(height: 30),
            buildSocialDivider(text: 'أو تسجيل الدخول باستخدام'),
            const SizedBox(height: 20),
            GoogleAuthButton(onPressed: _handleGoogleSignIn),
            const SizedBox(height: 30),
            buildLink(
              context: context,
              text: 'ليس لديك حساب؟ ',
              textButton: 'انشاء حساب جديد',
              routeName: RegisterScreen.id,
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic & Validation ---

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'البريد الالكتروني مطلوب';
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'صيغة البريد غير صحيحة';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.logInUser(
        context: context,
        userAccount: AppUser(email: _email!.trim(), password: _password!),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signInWithGoogle(context: context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
