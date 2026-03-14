import 'package:flutter/material.dart';
import 'package:subpay/widgets/cards/listTilePayment.dart';

class RequestPayment extends StatefulWidget {
  const RequestPayment({super.key});
  static String id = 'RequestPayment';

  @override
  State<RequestPayment> createState() => _RequestPaymentState();
}

class _RequestPaymentState extends State<RequestPayment> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.2;
    final double fontSize = screenWidth * 0.05;
    final double iconSize = screenWidth * 0.07;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ======= الهيدر =======
            Container(
              width: double.infinity,
              height: headerHeight,
              color: const Color(0xff140165),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'طلبات الدفع',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.02,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Image.asset(
                        'assets/icons/white_arrow_back.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======= الطلبات (قابلة للتمرير) =======
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                child: const ListTilePayment(), // فيها ListView.builder
              ),
            ),
          ],
        ),
      ),
    );
  }
}
