import 'package:flutter/material.dart';

/// Faixa de feedback que indica se a resposta do utilizador foi correta ou incorreta.
class QuizFeedbackBanner extends StatelessWidget {
  final bool isCorrect;
  final String correctLetter;

  const QuizFeedbackBanner({
    super.key,
    required this.isCorrect,
    required this.correctLetter,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? const Color(0xFF009191) : const Color(0xFFE25555);
    final bgColor = isCorrect ? const Color(0xFFE6F7F6) : const Color(0xFFFFF0F0);
    final text = isCorrect
        ? 'Correto! Muito bem.'
        : 'Incorreto. A resposta correta é a opção $correctLetter.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_outline : Icons.error_outline,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isCorrect ? const Color(0xFF005B5B) : const Color(0xFFB42318),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
