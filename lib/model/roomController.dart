import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subpay/auth/firebase/roomRepository%20.dart';

class RoomController {
  final RoomRepository _repository;

  RoomController(this._repository);

  Future<void> addRoom(String roomName) async {
    if (roomName.isEmpty) {
      throw Exception('Room name cannot be empty');
    }
    await _repository.createRoom(roomName);
  }

  Stream<QuerySnapshot> get roomsStream => _repository.getRoomsStream();
}
