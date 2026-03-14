import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customTextButton.dart';

Widget buildLink({
  required BuildContext context,
  required String text,
  required String textButton,
  required String routeName,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text, style: TextStyle(color: Colors.grey)),
      CustomTextButton(
        text: textButton,
        color: Colors.blueAccent,
        onPressed: () => Navigator.pushNamed(context, routeName),
      ),
    ],
  );
}
