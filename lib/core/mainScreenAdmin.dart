import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:subpay/auth/firebase/roomRepository%20.dart';
import 'package:subpay/model/roomController.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({super.key});
  static String id = 'MainScreenAdmin';

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  final RoomController _roomController = RoomController(RoomRepository());
  final TextEditingController _roomNameController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  Future<void> _showAddRoomDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Room'),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _roomController.addRoom(_roomNameController.text);
                  _roomNameController.clear();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.person_pin, size: screenWidth * 0.08),
          Text(
            'Your rooms',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, size: screenWidth * 0.08),
            onPressed: _showAddRoomDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomGrid(QuerySnapshot snapshot) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final room = snapshot.docs[index];
        final data = room.data() as Map<String, dynamic>;

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.room, size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              _buildHeader(context),
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
                    child: _buildRoomGrid(snapshot.data!),
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
