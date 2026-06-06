import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import 'custom_badge.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, spreadRadius: 1)],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 6, decoration: BoxDecoration(color: course.color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 45, height: 45,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: course.color.withOpacity(0.3), width: 2)),
                        alignment: Alignment.center,
                        child: Text(course.acronym.substring(0, 2), style: TextStyle(color: course.color, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(course.acronym, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(width: 8),
                                CustomBadge(text: course.type, textColor: const Color(0xFF009191), bgColor: const Color(0xFFE0F2F1), icon: Icons.school),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(course.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("${course.subjectsCount} cadeiras disponíveis", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(width: 8),
                                CustomBadge(text: course.area, textColor: course.color, bgColor: course.color.withOpacity(0.1)),
                              ],
                            )
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}