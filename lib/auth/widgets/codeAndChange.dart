import 'package:flutter/material.dart';

class CodeRoomChange extends StatelessWidget {
  const CodeRoomChange({
    super.key,
    required this.textCode,
    this.onEdit, // callback للتعديل
  });

  final String textCode;
  final VoidCallback? onEdit; // هنا هتستقبل الفنكشن اللي بتعمل تعديل

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.1,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.3 * 255).toInt()),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Code Of Room : ',
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: const Color.fromARGB(255, 96, 97, 99),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    TextSpan(
                      text: textCode,
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh_outlined, color: Colors.grey),
              onPressed: onEdit, // تستدعي الفنكشن اللي هتبعتها
            ),
          ],
        ),
      ),
    );
  }
}
