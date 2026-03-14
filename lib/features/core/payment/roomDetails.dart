import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/widgets/cards/codeAndChange.dart';
import 'package:subpay/utils/extension/contextExtension.dart';

class RoomDetails extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String roomCode;

  const RoomDetails({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.roomCode,
  });

  static String id = 'RoomDetails';

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _currentCode;

  final List<String> tabTitles = ['بيانات الرووم', 'المستخدمين'];

  // Controllers for email, password, and app password
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController appPasswordController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    _currentCode = widget.roomCode;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    appPasswordController = TextEditingController();

    // Load existing email, password, appPassword
    FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .get()
        .then((doc) {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            setState(() {
              emailController.text = data['email'] ?? '';
              passwordController.text = data['password'] ?? '';
              appPasswordController.text = data['appPassword'] ?? '';
            });
          }
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    appPasswordController.dispose();
    super.dispose();
  }

  String _generateNewCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<void> _regenerateCode() async {
    final confirm = await _showConfirmationDialog(
      "هل أنت متأكد أنك تريد توليد كود جديد للغرفة؟",
    );
    if (!confirm) return;

    final newCode = _generateNewCode();
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .update({'code': newCode});

    setState(() {
      _currentCode = newCode;
    });
  }

  Future<void> _deleteRoom() async {
    final confirm = await _showConfirmationDialog(
      "هل أنت متأكد أنك تريد حذف هذه الغرفة نهائيًا؟",
    );
    if (!confirm) return;

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .delete();

    if (mounted) Navigator.pop(context);
  }

  Future<bool> _showConfirmationDialog(String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("تأكيد"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("تأكيد"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _saveEmailPassword() async {
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .update({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'appPassword': appPasswordController.text.trim(),
        });
    context.showSnackBar(message: 'تم الحفظ بنجاح');
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
        child: SingleChildScrollView(
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
                          onPressed: _deleteRoom,
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: iconSize,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.roomName,
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
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                labelStyle: TextStyle(fontSize: fontSize * 0.9),
                tabs: tabTitles.map((title) => Tab(text: title)).toList(),
              ),
              SizedBox(
                height: screenHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: Column(
                        children: [
                          CodeRoomChange(
                            textCode: _currentCode,
                            onEdit: _regenerateCode,
                          ),
                          const SizedBox(height: 20),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: TextField(
                              controller: appPasswordController,
                              decoration: InputDecoration(
                                labelText: 'App Password',
                                labelStyle: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.03),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff140165),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.2,
                                vertical: screenHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _saveEmailPassword,
                            child: const Text('حفظ البريد وكلمة المرور'),
                          ),
                        ],
                      ),
                    ),
                    const Center(child: Text("Users list here...")),
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
