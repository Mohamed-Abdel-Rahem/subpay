import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class VodafoneCashPayment extends StatefulWidget {
  const VodafoneCashPayment({super.key});
  static String id = 'VodafoneCashPayment';
  @override
  State<VodafoneCashPayment> createState() => _VodafoneCashPaymentState();
}

class _VodafoneCashPaymentState extends State<VodafoneCashPayment> {
  Uint8List? _paymentImage; // عشان نخزن الصورة المختارة

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _paymentImage = bytes;
      });
    }
  }

  Future<void> _uploadPaymentProof() async {
    if (_paymentImage == null) {
      context.showSnack(message: 'من فضلك اختار صورة أولاً');
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        context.showSnack(message: 'لم يتم تسجيل الدخول');
        return;
      }

      final base64Image = base64Encode(_paymentImage!);

      await FirebaseFirestore.instance.collection('payments').add({
        'userEmail': user.email,
        'userName': user.displayName ?? 'غير معروف',
        'imageBase64': base64Image,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending', // الأدمن يغيرها لـ approved / rejected
      });

      context.showSnack(message: 'تم رفع صورة الدفع بنجاح');
      setState(() {
        _paymentImage = null; // بعد الرفع امسح الصورة من الشاشة
      });
    } catch (e) {
      context.showSnack(message: 'حصل خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.2;
    final double fontSize = screenWidth * 0.05;
    final double horizontalPadding = screenWidth * 0.05;
    final double iconSize = screenWidth * 0.07;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
                        'عن طريق المحفظة الالكترونية',
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

              SizedBox(height: screenHeight * 0.01),

              // ======= صورة الكاش =======
              Container(
                width: screenWidth * .6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xff140165), Color(0xffe60000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Image.asset('assets/images/cash.png'),
              ),

              Text(
                'محفظة الكترونية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: horizontalPadding),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff140165),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontSize: screenWidth * .1,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 248, 206, 206),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: screenWidth * .045,
                                fontFamily: 'Cairo',
                                color: const Color.fromARGB(255, 37, 37, 37),
                              ),
                              children: [
                                TextSpan(
                                  text: 'تحويل المبلغ :\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * .05,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      'برجاء تحويل المبلغ من أي خدمة كاش\n( اتصالات , فودافون , اورنج )',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 70, 67, 67),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(text: '+201025849793'),
                            );
                            context.showSnack(message: 'تم النسخ');
                          },
                          icon: Icon(
                            Icons.copy,
                            color: Color.fromARGB(255, 3, 78, 139),
                            size: screenWidth * .06,
                          ),
                        ),
                        Text(
                          '+201025849793',
                          style: TextStyle(
                            fontSize: screenWidth * .045,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 3, 78, 139),
                            decoration: TextDecoration.underline,
                            decorationColor: const Color.fromARGB(
                              255,
                              3,
                              78,
                              139,
                            ),
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: horizontalPadding),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff140165),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: screenWidth * .1,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 248, 206, 206),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: screenWidth * .045,
                                fontFamily: 'Cairo',
                                color: const Color.fromARGB(255, 37, 37, 37),
                              ),
                              children: [
                                TextSpan(
                                  text: ' رفع صورة التحويل : \n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * .05,
                                  ),
                                ),
                                const TextSpan(
                                  text:
                                      'برجاء رفع صورة التحويل'
                                      '\nلتوضيح نجاح عملية الدفع ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 70, 67, 67),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        margin: EdgeInsets.all(16),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 65, 63, 63),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _paymentImage == null
                            ? Center(
                                child: Text(
                                  'اضغط لرفع صورة الدفع',
                                  style: TextStyle(
                                    fontSize: screenWidth * .045,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Image.memory(_paymentImage!, fit: BoxFit.cover),
                      ),
                    ),
                    //onPressed: _uploadPaymentProof,
                    CustomButton(text: 'إرسال', onPressed: _uploadPaymentProof),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
