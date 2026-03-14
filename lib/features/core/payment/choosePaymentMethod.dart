import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subpay/widgets/cards/containerPayment.dart';
import 'package:subpay/features/core/payment/instaPay.dart';
import 'package:subpay/features/core/payment/digitalWallet.dart';

class ChoosePaymentMethod extends StatefulWidget {
  const ChoosePaymentMethod({super.key});
  static String id = 'ChoosePaymentMethod';

  @override
  State<ChoosePaymentMethod> createState() => _ChoosePaymentMethodState();
}

class _ChoosePaymentMethodState extends State<ChoosePaymentMethod> {
  final user = FirebaseAuth.instance.currentUser;

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

              SizedBox(height: screenHeight * 0.02),

              SizedBox(height: screenHeight * 0.03),

              // ====== Payment Options ======
              ContainerPayment(
                onPressed: () {
                  Navigator.pushNamed(context, DigitalWallet.id);
                },
                text: ' محفظة الكترونية',
                imagePath: 'assets/images/cash.png',
              ),
              ContainerPayment(
                onPressed: () {
                  Navigator.pushNamed(context, InstaPayPayment.id);
                },
                text: 'انستا باي',
                imagePath: 'assets/images/insta.png',
              ),

              // ====== Payment Status ======
              if (user != null)
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('payments')
                      .doc(
                        user!.uid,
                      ) // بيفترض إن كل يوزر له دوكومنت في payments
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const SizedBox(); // لو مفيش دفع لسه
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final status = data['status'] ?? 'pending';

                    Color statusColor;
                    String statusText;

                    switch (status) {
                      case 'approved':
                        statusColor = Colors.green;
                        statusText = 'تمت الموافقة على الدفع';
                        break;
                      case 'rejected':
                        statusColor = Colors.red;
                        statusText = 'تم رفض الدفع';
                        break;
                      default:
                        statusColor = Colors.orange;
                        statusText = 'في انتظار تأكيد الدفع';
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.015,
                        horizontal: horizontalPadding,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: statusColor, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              status == 'approved'
                                  ? Icons.check_circle
                                  : status == 'rejected'
                                  ? Icons.cancel
                                  : Icons.hourglass_bottom,
                              color: statusColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: fontSize * 0.9,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
