import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/services/roomRepository%20.dart';
import 'package:subpay/widgets/cards/addRoomDailog.dart';
import 'package:subpay/widgets/cards/headerWidget.dart';
import 'package:subpay/widgets/cards/roomGrid.dart';
import 'package:subpay/features/core/payment/requests.dart';
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

    return Directionality(
      textDirection: TextDirection.ltr, // هنا نحول الشاشة بالكامل إلى LTR
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: const Color(0xff140165), // لون الخلفية نفس الهيدر
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xff140165)),
                  child: Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                  onTap: () {
                    Navigator.pop(context); // يغلق الدروار
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.notification_add,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Requests',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, RequestPayment.id);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.2,
                  color: const Color(0xff140165),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'الصفحة الرئيسية',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Builder(
                          builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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
                        horizontal: screenWidth * 0.05,
                      ),
                      child: RoomGrid(snapshot: snapshot.data!),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
