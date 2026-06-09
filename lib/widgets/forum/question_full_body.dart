import 'package:flutter/material.dart';
import '../../models/forum/question.dart';

/// Corpo completo de uma pergunta com título, tags e descrição.
class QuestionFullBody extends StatelessWidget {
  final Question question;

  const QuestionFullBody({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D204B), height: 1.3),
        ),
        const SizedBox(height: 12),

        if (question.tags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: question.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF2F5F7), borderRadius: BorderRadius.circular(6)),
              child: Text("#$tag", style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            )).toList(),
          ),

        const SizedBox(height: 16),

        Text(
          question.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 14, color: Color(0xFF4F4F4F), height: 1.6),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
