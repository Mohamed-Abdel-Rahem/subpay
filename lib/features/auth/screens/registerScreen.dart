import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:subpay/features/auth/screens/loginScreen.dart';
import 'package:subpay/features/auth/widgets/build_divder.dart';
import 'package:subpay/features/auth/widgets/build_header.dart';
import 'package:subpay/features/auth/widgets/build_input_register.dart';
import 'package:subpay/features/auth/widgets/build_ink.dart';
import 'package:subpay/features/auth/widgets/buttons/google_button.dart';
import 'package:subpay/features/auth/widgets/terms_permission.dart';
import 'package:subpay/services/firebase_services_auth.dart';
import 'package:subpay/widgets/buttons/customButton.dart';
import 'package:subpay/model/app_user.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- State Variables ---
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isChecked = false;
  bool _isLoading = false;
  String? _email, _password, _username, _phone;

  @override
  void dispose() {
    AuthService.instance.dispose();
    super.dispose();
  }

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
              child: _buildFormContent(),
            ),
          ),
        ),
      ),
    );
  }

  // --- Main Form Content ---
  Widget _buildFormContent() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(
              text: 'انشاء حساب جديد',
              subText: 'انضم إلينا وابدأ إدارة اشتراكاتك بسهولة',
              icon: Icons.person_add_alt_1_rounded,
            ),
            const SizedBox(height: 30),
            // جوه الـ Column في _buildFormContent
            RegisterInputFields(
              onUsernameChanged: (value) => _username = value,
              onPhoneChanged: (value) => _phone = value,
              onEmailChanged: (value) => _email = value,
              onPasswordChanged: (value) => _password = value,
              emailValidator: _validateEmail,
            ),
            const SizedBox(height: 10),
            // جوه الـ Column
            TermsAndConditionsSection(
              onChanged: (val) {
                _isChecked =
                    val; // بتحدث المتغير اللي عندك في الـ Screen عشان الـ handleRegister
              },
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'انشاء حساب', onPressed: _handleRegister),
            const SizedBox(height: 20),
            buildSocialDivider(text: 'أو التسجيل باستخدام'),
            const SizedBox(height: 20),
            // جوه الـ Column في _buildFormContent
            GoogleAuthButton(onPressed: _handleGoogleSignIn),
            const SizedBox(height: 20),
            buildLink(
              context: context,
              text: 'لديك حساب؟ ',
              textButton: 'تسجيل الدخول',
              routeName: LoginScreen.id,
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Component Methods ---

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'البريد الالكتروني مطلوب';
    final emailRegex = RegExp(r'\S+@\S+\.\S+');
    if (!emailRegex.hasMatch(value)) return 'صيغة البريد غير صحيحة';
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_isChecked) {
      context.showSnackBar(
        message: 'يجب عليك الموافقة على الشروط والأحكام للمتابعة.',
        color: Colors.orange,
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.instance.createAccount(
        context: context,
        userAccount: AppUser(
          email: _email!.trim(),
          password: _password!,
          name: _username!.trim(),
          phone: _phone!.trim(),
        ),
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
