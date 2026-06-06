import 'package:flutter/material.dart';

import '../../widgets/about_us_content_card.dart';
import '../../widgets/app_header_actions.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D204B)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Color(0xFF1D204B),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          AppBalanceChip(),
          AppUserAvatar(initials: 'MR'),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Center(child: const AboutUsContentCard()),
        ),
      ),
    );
  }
}
