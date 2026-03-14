import 'package:flutter/material.dart';

class TermsAndConditionsSection extends StatefulWidget {
  final Function(bool) onChanged;

  const TermsAndConditionsSection({super.key, required this.onChanged});

  @override
  State<TermsAndConditionsSection> createState() =>
      _TermsAndConditionsSectionState();
}

class _TermsAndConditionsSectionState extends State<TermsAndConditionsSection> {
  bool _isChecked = false;

  void _toggleCheck(bool? value) {
    setState(() {
      _isChecked = value ?? !_isChecked;
    });
    widget.onChanged(_isChecked); // بنبعت الحالة الجديدة للشاشة الأساسية
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          activeColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: _toggleCheck,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => _toggleCheck(null),
            child: const Text(
              'أوافق على الشروط والأحكام',
              style: TextStyle(
                color: Color(0xff6A8DC1),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
