import 'package:flutter/material.dart';
import '../../models/forum/school.dart';
import 'custom_badge.dart';

class SchoolCard extends StatelessWidget {
  final School school;
  final VoidCallback onTap;

  const SchoolCard({super.key, required this.school, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(school.icon, size: 40, color: Colors.grey[700]),
            const SizedBox(height: 12),
            Text(school.acronym, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1D204B))),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(school.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ),
            const SizedBox(height: 12),
            CustomBadge(
              text: "${school.coursesCount} cursos",
              textColor: const Color(0xFF009191),
              bgColor: const Color(0xFFE0F2F1),
            )
          ],
        ),
      ),
    );
  }
}