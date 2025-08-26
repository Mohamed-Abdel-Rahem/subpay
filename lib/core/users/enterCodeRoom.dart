import 'package:flutter/material.dart';
import 'package:subpay/auth/widgets/customButton.dart';
import 'package:subpay/auth/widgets/customTextBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/core/users/choosePaymentMethod.dart';
import 'package:subpay/core/users/roomDetailsMember.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class EnterCodeRoom extends StatefulWidget {
  const EnterCodeRoom({super.key});
  static String id = 'EnterCodeRoom';

  @override
  State<EnterCodeRoom> createState() => _EnterCodeRoomState();
}

class _EnterCodeRoomState extends State<EnterCodeRoom> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      context.showSnack(message: 'من فضلك أدخل كود الغرفة');

      return;
    }

    try {
      final query = await _firestore
          .collection('rooms')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        context.showSnack(message: 'لم يتم العثور على الغرفة');

        return;
      }

      final roomDoc = query.docs.first;

      // نفتح صفحة تفاصيل الغرفة ونبعت الـ roomId فقط
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => RoomDetailsMember(roomId: roomDoc.id),
      //   ),
      // );
      // Navigator.pushNamed(context, RoomDetailsMember.id,
      //     arguments: roomDoc.id);
      Navigator.pushNamed(context, ChoosePaymentMethod.id);
    } catch (e) {
      context.showSnack(message: 'حصل خطأ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: screenHeight * 0.2,
                color: const Color(0xff140165),
                child: Center(
                  child: Text(
                    'الانضمام للغرفة',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              CustomInputField(
                label: 'الكود',
                hint: 'ادخل كود الغرفة',
                data: _codeController,
                onChanged: (value) {},
              ),
              SizedBox(height: screenHeight * 0.045),
              CustomButton(text: 'ادخل كود الغرفة', onPressed: _joinRoom),
            ],
          ),
        ),
      ),
    );
  }
}
