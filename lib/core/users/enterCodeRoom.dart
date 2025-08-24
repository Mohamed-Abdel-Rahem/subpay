import 'package:flutter/material.dart';

class EnterCodeRoom extends StatefulWidget {
  const EnterCodeRoom({super.key});
  static String id = 'EnterCodeRoom';
  @override
  State<EnterCodeRoom> createState() => _EnterCodeRoomState();
}

class _EnterCodeRoomState extends State<EnterCodeRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code Room')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logic to enter code room
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Entered code room successfully!')),
            );
          },
          child: const Text('Enter Code Room'),
        ),
      ),
    );
  }
}
