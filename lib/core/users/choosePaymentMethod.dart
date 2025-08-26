import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/containerPayment.dart';
import 'package:subpay/auth/widgets/customText.dart';
import 'package:subpay/core/users/vodafoneCash.dart';

class ChoosePaymentMethod extends StatefulWidget {
  const ChoosePaymentMethod({super.key});
  static String id = 'ChoosePaymentMethod';

  @override
  State<ChoosePaymentMethod> createState() => _ChoosePaymentMethodState();
}

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.2;
    final double fontSize = screenWidth * 0.05;
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ====== Header ======
              Container(
                width: double.infinity,
                height: headerHeight,
                color: const Color(0xff140165),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'اختر طريقة الدفع',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.045),

              // ====== Instruction Text ======
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: screenHeight * 0.01,
                ),
                child: Center(
                  child: Text(
                    'يرجى إتمام عملية الدفع قبل الانضمام للغرفة.\nاختر وسيلة الدفع المناسبة لك وارفع صورة إيصال الدفع ليتم تأكيد انضمامك.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize * 0.8,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // ====== Payment Options ======
              ContainerPayment(
                onPressed: () {
                  Navigator.pushNamed(context, VodafoneCashPayment.id);
                },
                text: ' محفظة الكترونية',
                imagePath: 'assets/images/cash.png',
              ),
              ContainerPayment(
                onPressed: () {
                  // هنا هاتوجه لرفع السكرين شوت مثلاً
                },
                text: 'انستا باي',
                imagePath: 'assets/images/insta.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
