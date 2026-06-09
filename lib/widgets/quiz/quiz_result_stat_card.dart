import 'package:flutter/material.dart';

/// Cartão de estatística resumida para o ecrã de resultado do quiz.
class QuizResultStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color backgroundColor;

  const QuizResultStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF5F6368), fontSize: 12)),
        ],
      ),
    );
  }
}
