import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:subpay/widgets/inputs/customText.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static String id = 'UserProfile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // الألوان والقياسات الثابتة في متغيرات عشان لو حبيت تغير الثيم كله مرة واحدة
  final Color backgroundColor = const Color(0xFFF5F5F7);
  final Color primaryAccent = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            _buildHeaderSection(),
            const SizedBox(height: 30),
            _buildInfoCardSection(),
          ],
        ),
      ),
    );
  }

  // --- 1. الـ AppBar المنظم ---
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.logout, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [_buildMirroredBackButton(context)],
    );
  }

  Widget _buildMirroredBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  // --- 2. قسم الرأس (Avatar + Name + Edit Button) ---
  Widget _buildHeaderSection() {
    return Column(
      children: [
        _buildAvatar(),
        const SizedBox(height: 16),
        CustomText(
          text: 'Mohamed Abdel Rahem',
          fontSize: 22,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: '@m_abdelrahem',
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 24),
        _buildEditButton(),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: primaryAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Icon(Icons.person_rounded, size: 70, color: primaryAccent),
    );
  }

  Widget _buildEditButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 12),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: () {},
      child: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }

  // --- 3. قسم بيانات المستخدم (الـ Card المنحني) ---
  Widget _buildInfoCardSection() {
    return Container(
      width: double.infinity,
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        child: Column(
          children: [
            _buildProfileInfoItem(
              label: 'Full Name',
              value: 'Mohamed Abdel Rahem',
              icon: Icons.person_outline,
            ),
            _buildDivider(),
            _buildProfileInfoItem(
              label: 'Email Address',
              value: 'm.abdelrahem@example.com',
              icon: Icons.email_outlined,
            ),
            _buildDivider(),
            _buildProfileInfoItem(
              label: 'Phone Number',
              value: '+20 123 456 7890',
              icon: Icons.phone_android_outlined,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لتصميم الكارد
  BoxDecoration _buildCardDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(40)),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
      ],
    );
  }

  Widget _buildDivider() => const Divider(height: 40, thickness: 0.5);

  Widget _buildProfileInfoItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        _buildIconBox(icon),
        const SizedBox(width: 20),
        _buildLabelValueTexts(label, value),
      ],
    );
  }

  Widget _buildIconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22, color: primaryAccent),
    );
  }

  Widget _buildLabelValueTexts(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 12,
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 2),
        CustomText(
          text: value,
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
