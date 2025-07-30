import 'package:cloud_firestore/cloud_firestore.dart';

class RoomRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new room with just name (no image)
  Future<void> createRoom(String roomName) async {
    try {
      await _firestore.collection('rooms').add({
        'name': roomName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  // Get all rooms stream
  Stream<QuerySnapshot> getRoomsStream() {
    return _firestore.collection('rooms').orderBy('createdAt').snapshots();
  }
}
