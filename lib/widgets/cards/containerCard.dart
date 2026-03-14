import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  const ContainerCard({super.key, required this.textEmail, this.textPassword});
  final String textEmail;
  final String? textPassword;
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
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft, //
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Chat GPT Email : ', // الجزء الأول
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: const Color.fromARGB(
                          255,
                          96,
                          97,
                          99,
                        ), // اللون المختلف هنا
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    TextSpan(
                      text: textEmail, // الجزء التاني (الإيميل أو النص المتغير)
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: Colors.blueAccent, // لون مختلف
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

            Align(
              alignment: Alignment.topLeft, //
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Password : ', // الجزء الأول
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: const Color.fromARGB(
                          255,
                          96,
                          97,
                          99,
                        ), // اللون المختلف هنا
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    TextSpan(
                      text:
                          textPassword, // الجزء التاني (الإيميل أو النص المتغير)
                      style: TextStyle(
                        fontSize: screenWidth * .035,
                        color: Colors.black, // لون مختلف
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
          ],
        ),
      ),
    );
  }
}
