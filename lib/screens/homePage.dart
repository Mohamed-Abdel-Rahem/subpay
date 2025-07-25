import 'package:flutter/material.dart';
import 'package:subpay/generated/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String id = 'HomePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).title)),
      body: const Center(
        child: Text('Welcome to the app!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
