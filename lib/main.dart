import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subpay/auth/screens/forgetPasswordPage.dart';
import 'package:subpay/auth/screens/loginScreen.dart';
import 'package:subpay/auth/screens/registerScreen.dart';
import 'package:subpay/core/users/choosePaymentMethod.dart';
import 'package:subpay/core/users/enterCodeRoom.dart';
import 'package:subpay/core/screens/mainScreenAdmin.dart';
import 'package:subpay/core/users/vodafoneCash.dart';
import 'package:subpay/generated/l10n.dart';
import 'package:subpay/auth/screens/homePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:subpay/auth/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  String initialRoute = SplashScreen.id;
  try {
    await Firebase.initializeApp();
    runApp(
      DevicePreview(
        enabled: true,
        tools: const [...DevicePreview.defaultTools],
        builder: (context) => SubPayApp(initialRoute: initialRoute),
      ),
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
}

class SubPayApp extends StatelessWidget {
  final String initialRoute;

  const SubPayApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      initialRoute: initialRoute,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        HomePage.id: (context) => const HomePage(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        ForgetPassword.id: (context) => const ForgetPassword(),
        MainScreenAdmin.id: (context) => const MainScreenAdmin(),
        EnterCodeRoom.id: (context) => const EnterCodeRoom(),
        ChoosePaymentMethod.id: (context) => const ChoosePaymentMethod(),
        VodafoneCashPayment.id: (context) => const VodafoneCashPayment(),
      },
    );
  }
}
