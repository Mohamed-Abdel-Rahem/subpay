import 'package:flutter/material.dart';

class GenerateCode extends StatefulWidget {
  const GenerateCode({super.key});
  static String id = 'GenerateCode';
  @override
  State<GenerateCode> createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Code')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logic to generate code
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Code generated successfully!')),
            );
          },
          child: const Text('Generate Code'),
        ),
      ),
    );
  }
}
