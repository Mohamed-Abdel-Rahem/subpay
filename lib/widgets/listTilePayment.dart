import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:subpay/features/core/payment/paymentDetails.dart';

class ListTilePayment extends StatefulWidget {
  const ListTilePayment({super.key});

  @override
  State<ListTilePayment> createState() => _ListTilePaymentState();
}

class _ListTilePaymentState extends State<ListTilePayment> {
  bool isSelectionMode = false; // وضع التحديد
  Set<String> selectedDocs = {}; // تخزين الـ docIds المختارة

  void toggleSelection(String docId) {
    setState(() {
      if (selectedDocs.contains(docId)) {
        selectedDocs.remove(docId);
        if (selectedDocs.isEmpty) isSelectionMode = false;
      } else {
        selectedDocs.add(docId);
      }
    });
  }

  void deleteSelected() async {
    for (var docId in selectedDocs) {
      await FirebaseFirestore.instance
          .collection("payments")
          .doc(docId)
          .delete();
    }
    setState(() {
      isSelectionMode = false;
      selectedDocs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double imageSize = screenWidth * 0.12;
    final double titleFontSize = screenWidth * 0.045;
    final double subtitleFontSize = screenWidth * 0.035;
    final double iconSize = screenWidth * 0.04;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("payments").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "🚫 No payment requests yet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return Scaffold(
          appBar: isSelectionMode
              ? AppBar(
                  backgroundColor: Colors.red,
                  title: Text("${selectedDocs.length} selected"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: deleteSelected,
                    ),
                  ],
                )
              : null,
          body: ListView.builder(
            padding: EdgeInsets.all(screenWidth * 0.03),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              Uint8List? imageBytes;
              if (data["imageBase64"] != null) {
                imageBytes = base64Decode(data["imageBase64"]);
              }

              bool isSelected = selectedDocs.contains(doc.id);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isSelected
                    ? Colors.blue.withAlpha((0.2 * 255).toInt())
                    : null,

                child: ListTile(
                  leading: imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                          child: Image.memory(
                            imageBytes,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.image, size: imageSize, color: Colors.grey),
                  title: Text(
                    data["username"] ?? "Unknown User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                    child: Text(
                      "Method: ${data["paymentMethod"] ?? ''}\nStatus: ${data["status"] ?? 'pending'}",
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        height: 1.4,
                        color: data["status"] == "approved"
                            ? Colors.green
                            : data["status"] == "rejected"
                            ? Colors.red
                            : Colors.orange,
                      ),
                    ),
                  ),
                  trailing: isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            toggleSelection(doc.id);
                          },
                        )
                      : Icon(Icons.arrow_forward_ios, size: iconSize),
                  onTap: () {
                    if (isSelectionMode) {
                      toggleSelection(doc.id);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentDetailsPage(
                            docId: doc.id,
                            data: data,
                            imageBytes: imageBytes,
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      isSelectionMode = true;
                      selectedDocs.add(doc.id);
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
