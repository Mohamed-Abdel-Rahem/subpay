import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseGetData {
  String name;
  String email;
  String gender;

  FirebaseGetData({
    required this.name,
    required this.email,
    required this.gender,
  });

  static CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  static final currentUser = FirebaseAuth.instance.currentUser;

  static Future<FirebaseGetData?> fetchAccountInformation() async {
    try {
      if (currentUser != null) {
        String? email = currentUser?.email; // Get current user's email
        DocumentSnapshot documentSnapshot = await users.doc(email).get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          return FirebaseGetData(
            name: data['username'] ?? '',
            email: data['email'] ?? '',
            gender: data['gender'] ?? '',
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
