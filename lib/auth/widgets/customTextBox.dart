import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: screenWidth * 0.02,
                  offset: Offset(0, screenHeight * 0.003),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: widget.isPassword ? _obscureText : false,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.04,
                ),
                hintTextDirection: TextDirection.rtl,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.018,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          size: screenWidth * 0.034,
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
