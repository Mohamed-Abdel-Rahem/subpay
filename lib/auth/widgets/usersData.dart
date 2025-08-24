import 'package:flutter/material.dart';

Widget BuildContainerOfUsersData({
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Builder(
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.015,
            horizontal: screenWidth * 0.04,
          ),
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9E9E9E).withAlpha(51),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: screenHeight * 0.026,
                backgroundImage: const AssetImage('assets/icons/person.png'),
                backgroundColor: Colors.white,
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenHeight * 0.022,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.006),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        color: const Color.fromARGB(255, 107, 106, 106),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 224, 112, 104),
                  size: screenHeight * 0.04,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
