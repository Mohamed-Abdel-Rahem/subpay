import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customTextBox.dart'; // تأكد من المسار الصحيح للـ CustomInputField

class LoginInputFields extends StatelessWidget {
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final String? Function(String?)? emailValidator;

  const LoginInputFields({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          label: 'البريد الالكتروني',
          hint: 'example@mail.com',
          onChanged: onEmailChanged,
          validator: emailValidator,
        ),
        const SizedBox(
          height: 16,
        ), // وحدت الـ height لـ 16 زي الـ Register للتناسق
        CustomInputField(
          label: 'كلمة المرور',
          hint: '********',
          isPassword: true,
          onChanged: onPasswordChanged,
          validator: (value) =>
              (value == null || value.isEmpty) ? 'كلمة المرور مطلوبة' : null,
        ),
      ],
    );
  }
}
