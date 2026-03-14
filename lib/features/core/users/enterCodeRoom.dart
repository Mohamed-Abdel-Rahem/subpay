import 'package:flutter/material.dart';
import 'package:subpay/widgets/buttons/customButton.dart';
import 'package:subpay/widgets/inputs/customTextBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/features/core/payment/choosePaymentMethod.dart';
import 'package:subpay/features/core/users/roomDetailsMember.dart';
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

  bool _isLoading = false;

  Future<void> _joinRoom() async {
    final code = _codeController.text.trim();

    if (code.isEmpty) {
      context.showSnackBar(message: 'من فضلك أدخل كود الغرفة');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final query = await _firestore
          .collection('rooms')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        context.showSnackBar(message: 'لم يتم العثور على الغرفة');
      } else {
        final roomDoc = query.docs.first;

        Navigator.pushNamed(context, ChoosePaymentMethod.id);
        // أو:
        // Navigator.pushNamed(context, RoomDetailsMember.id, arguments: roomDoc.id);
      }
    } catch (e) {
      context.showSnackBar(message: 'حصل خطأ: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(text: 'ادخل كود الغرفة', onPressed: _joinRoom),
            ],
          ),
        ),
      ),
    );
  }
}
