import 'package:flutter/material.dart';
import '../../screens/quiz/quiz_models.dart';

class QuizQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6EAEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'PERGUNTA $questionNumber',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D204B),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              question.category,
              style: const TextStyle(
                color: Color(0xFF009191),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
