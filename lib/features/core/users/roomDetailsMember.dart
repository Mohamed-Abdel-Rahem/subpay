import 'package:flutter/material.dart';
import 'package:subpay/widgets/cards/containerCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/features/core/users/enterCodeRoom.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class RoomDetailsMember extends StatefulWidget {
  final String roomId;

  static String id = 'RoomDetailsMember';
  const RoomDetailsMember({super.key, required this.roomId});

  @override
  State<RoomDetailsMember> createState() => _RoomDetailsMemberState();
}

class _RoomDetailsMemberState extends State<RoomDetailsMember> {
  String? email;
  String? password;
  String? name;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoomDetails();
  }

  Future<void> _loadRoomDetails() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .get();

      if (doc.exists) {
        setState(() {
          name = doc['name'] ?? 'بدون اسم';
          email = doc['email'] ?? '';
          password = doc['password'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      context.showSnackBar(message: 'خطأ أثناء تحميل بيانات الغرفة: $e');
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأكيد الخروج"),
        content: const Text("هل أنت متأكد من الخروج من الغرفة؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // إلغاء
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق الديالوج
              Navigator.pushReplacementNamed(
                context,
                EnterCodeRoom.id,
              ); // الذهاب لشاشة إدخال الكود
            },
            child: const Text("نعم"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.2;
    final double iconSize = screenWidth * 0.07;
    final double fontSize = screenWidth * 0.05;
    final double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: headerHeight,
                      color: const Color(0xff140165),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _confirmLogout, // ✨ هنا ربطنا الخروج
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.redAccent,
                                  size: iconSize,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  name ?? '',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Image.asset(
                                  'assets/icons/white_arrow_back.png',
                                  width: iconSize,
                                  height: iconSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.03,
                          horizontal: screenWidth * 0.05,
                        ),
                        child: ContainerCard(
                          textEmail: email ?? '',
                          textPassword: password ?? '',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
