import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customTextButton.dart';

Widget buildForgotPasswordLink({
  required String routeName,
  required BuildContext context,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: CustomTextButton(
      text: 'نسيت كلمة المرور؟',
      color: Colors.blueAccent,
      onPressed: () => Navigator.pushNamed(context, routeName),
    ),
  );
}
