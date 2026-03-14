import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;
  final Uint8List? imageBytes;

  const PaymentDetailsPage({
    super.key,
    required this.docId,
    required this.data,
    required this.imageBytes,
  });

  void _updateStatus(BuildContext context, String newStatus) async {
    await FirebaseFirestore.instance.collection("payments").doc(docId).update({
      "status": newStatus,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Status updated to $newStatus ",
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: newStatus == "approved" ? Colors.green : Colors.red,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = data["status"] ?? "pending";
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth > 600;
            final padding = isTablet ? 24.0 : 16.0;
            final titleSize = isTablet ? 22.0 : 18.0;
            final textSize = isTablet ? 20.0 : 16.0;
            final buttonHeight = isTablet ? 60.0 : 50.0;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// صورة الدفع
                  if (imageBytes != null)
                    Container(
                      height: size.height * (isTablet ? 0.6 : 0.5),
                      width: double.infinity,
                      color: Colors.black,
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 5,
                        child: Image.memory(imageBytes!, fit: BoxFit.contain),
                      ),
                    )
                  else
                    SizedBox(
                      height: size.height * 0.3,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                  SizedBox(height: isTablet ? 30 : 20),

                  /// بيانات الدفع
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            "👤 User : ${data["username"] ?? "Unknown"}",
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "💳 Method: ${data["paymentMethod"] ?? ''}",
                            style: TextStyle(
                              fontSize: textSize,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                currentStatus.toUpperCase(),
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: currentStatus == "approved"
                                      ? Colors.green
                                      : currentStatus == "rejected"
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                              Text(
                                " : Status ",
                                style: TextStyle(
                                  fontSize: textSize,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 30 : 20),

                  /// الأزرار
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(double.infinity, buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _updateStatus(context, "approved"),
                            icon: const Icon(Icons.check),
                            label: Text(
                              "Approve",
                              style: TextStyle(fontSize: textSize),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(double.infinity, buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _updateStatus(context, "rejected"),
                            icon: const Icon(Icons.close),
                            label: Text(
                              "Reject",
                              style: TextStyle(fontSize: textSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
