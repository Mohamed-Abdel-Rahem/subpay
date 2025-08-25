import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:subpay/auth/firebase/roomRepository%20.dart';
import 'package:subpay/model/RoomModel.dart';

class RoomController {
  final RoomRepository _repo;

  RoomController(this._repo);

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789';
    return List.generate(
      6,
      (i) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  Future<void> createRoom(String name, String imageBase64) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final code = _generateCode();
    final room = RoomModel(
      id: '', // Firestore ID auto generated
      name: name,
      imageBase64: imageBase64,
      code: code,
      ownerId: uid,
      members: [uid],
      createdAt: DateTime.now(),
    );
    await _repo.createRoom(room);
  }

  Stream<QuerySnapshot> get roomsStream => _repo.getRoomsStream();

  Future<void> joinRoomByCode(String code, String userId) async {
    final doc = await _repo.getRoomByCode(code);
    if (doc == null) throw Exception("Room not found.");
    await _repo.joinRoom(doc.id, userId);
  }
}
