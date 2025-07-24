import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subpay/screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    await Firebase.initializeApp();
    runApp(
      DevicePreview(
        enabled: true,
        tools: const [...DevicePreview.defaultTools],
        builder: (context) => const SubPayApp(),
      ),
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
}

class SubPayApp extends StatelessWidget {
  const SubPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
