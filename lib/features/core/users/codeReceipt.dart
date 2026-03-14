// import 'package:flutter/material.dart';

// class CodeReceipt extends StatefulWidget {
//   const CodeReceipt({super.key});
//   static const String id = 'CodeReceipt';
//   @override
//   State<CodeReceipt> createState() => _CodeReceiptState();
// }

// class _CodeReceiptState extends State<CodeReceipt> {
//  String? otp;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('rooms')
//           .doc(widget.roomId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return CircularProgressIndicator();
//         final data = snapshot.data!.data() as Map<String, dynamic>;
//         final email = data['roomEmail'];
//         final password = data['roomPassword'];

//         return Scaffold(
//           appBar: AppBar(title: Text('Room Credentials')),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Email: $email"),
//                 Text("Password: $password"),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     setState(() => isLoading = true);
//                     final code = await fetchLatestOtp(email, password);
//                     setState(() {
//                       otp = code;
//                       isLoading = false;
//                     });
//                   },
//                   child: isLoading ? CircularProgressIndicator() : Text("Get OTP"),
//                 ),
//                 if (otp != null) Text("Latest OTP: $otp", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
