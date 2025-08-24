import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/auth/firebase/roomRepository%20.dart';
import 'package:subpay/auth/widgets/addRoomDailog.dart';
import 'package:subpay/auth/widgets/headerWidget.dart';
import 'package:subpay/auth/widgets/roomGrid.dart';
import 'package:subpay/model/roomController.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({super.key});
  static String id = 'MainScreenAdmin';

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  final RoomController _roomController = RoomController(RoomRepository());

  Future<void> _handleAddRoomDialog() async {
    final result = await AddRoomDialog.show(context);
    if (result != null) {
      final String name = result['name'];
      final String imageBase64 = result['image'];
      await _roomController.createRoom(name, imageBase64);
      setState(() {}); // لتحديث الشاشة بعد إضافة الغرفة
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
                    'الصفحة الرئيسية',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.045),
              HeaderWidget(onAddPressed: _handleAddRoomDialog),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _roomController.roomsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: RoomGrid(snapshot: snapshot.data!),
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
