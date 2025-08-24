import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/model/RoomModel.dart';

class RoomRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createRoom(RoomModel room) async {
    final doc = _firestore.collection('rooms').doc();
    await doc.set(room.toMap());
  }

  Stream<QuerySnapshot> getRoomsStream() {
    return _firestore.collection('rooms').orderBy('createdAt').snapshots();
  }

  Future<DocumentSnapshot?> getRoomByCode(String code) async {
    final query = await _firestore
        .collection('rooms')
        .where('code', isEqualTo: code)
        .get();
    return query.docs.isNotEmpty ? query.docs.first : null;
  }

  Future<void> joinRoom(String roomId, String userId) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    final snapshot = await roomRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    List members = data['members'];

    if (members.length >= 10) {
      throw Exception("Room is full.");
    }
    if (members.contains(userId)) {
      throw Exception("Already joined.");
    }

    members.add(userId);
    await roomRef.update({'members': members});
  }
}
