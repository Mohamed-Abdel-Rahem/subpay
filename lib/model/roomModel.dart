class RoomModel {
  final String id;
  final String name;
  final String imageBase64;
  final String code;
  final String ownerId;
  final List<String> members;
  final DateTime createdAt;
  String email;
  String password;
  RoomModel({
    required this.id,
    required this.name,
    required this.imageBase64,
    required this.code,
    required this.ownerId,
    required this.members,
    required this.createdAt,
    this.email = '',
    this.password = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': imageBase64,
      'code': code,
      'ownerId': ownerId,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RoomModel.fromMap(String id, Map<String, dynamic> map) {
    return RoomModel(
      id: id,
      name: map['name'] ?? '',
      imageBase64: map['image'] ?? '',
      code: map['code'] ?? '',
      ownerId: map['ownerId'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
