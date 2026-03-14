class AppUser {
  String? name;
  final String email;
  String? phone;
  final String password;
  String? uId;

  AppUser({
    this.name,
    required this.email,
    this.phone,
    required this.password,
    this.uId,
  });
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      password: map['password'] ?? '',
      uId: map['uId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'uId': uId};
  }
}
