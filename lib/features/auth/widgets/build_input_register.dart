import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customTextBox.dart'; // تأكد من اسم الكلاس عندك (CustomInputField أو CustomTextBox)

class RegisterInputFields extends StatelessWidget {
  final Function(String) onUsernameChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final String? Function(String?)? emailValidator;

  const RegisterInputFields({
    super.key,
    required this.onUsernameChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    this.emailValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInputField(
          label: 'اسم المستخدم',
          hint: 'مثال: محمد أحمد',
          onChanged: onUsernameChanged,
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'اسم المستخدم مطلوب' : null,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'رقم الهاتف',
          hint: '01xxxxxxxxx',
          onChanged: onPhoneChanged,
          validator: (value) =>
              (value?.isEmpty ?? true) ? 'رقم الهاتف مطلوب' : null,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'البريد الالكتروني',
          hint: 'example@mail.com',
          onChanged: onEmailChanged,
          validator: emailValidator,
        ),
        const SizedBox(height: 16),
        CustomInputField(
          label: 'كلمة المرور',
          hint: '********',
          isPassword: true,
          onChanged: onPasswordChanged,
          validator: (value) => (value != null && value.length < 6)
              ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
              : null,
        ),
      ],
    );
  }
}
