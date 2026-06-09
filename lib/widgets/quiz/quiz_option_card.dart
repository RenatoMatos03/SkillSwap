import 'package:flutter/material.dart';
import '../../models/quiz_models.dart';

/// Cartão de opção de resposta do quiz com estados visuais de seleção e correção.
class QuizOptionCard extends StatelessWidget {
  final QuizOption option;
  final bool isSelected;
  final bool isAnswered;
  final VoidCallback? onTap;

  const QuizOptionCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color backgroundColor;
    final Color textColor;
    final Color badgeColor;
    final Color badgeTextColor;
    Widget? trailingIcon;

    if (isAnswered) {
      if (option.isCorrect) {
        backgroundColor = const Color(0xFFE6F7F6);
        borderColor = const Color(0xFF009191);
        textColor = const Color(0xFF005B5B);
        badgeColor = const Color(0xFF009191);
        badgeTextColor = Colors.white;
        trailingIcon = const Icon(Icons.check_circle, color: Color(0xFF009191), size: 22);
      } else if (isSelected) {
        backgroundColor = const Color(0xFFFFECEC);
        borderColor = const Color(0xFFE25555);
        textColor = const Color(0xFFB42318);
        badgeColor = const Color(0xFFE25555);
        badgeTextColor = Colors.white;
        trailingIcon = const Icon(Icons.close_rounded, color: Color(0xFFE25555), size: 22);
      } else {
        backgroundColor = const Color(0xFFF8FAFC);
        borderColor = const Color(0xFFE3E8EF);
        textColor = const Color(0xFF98A2B3);
        badgeColor = const Color(0xFFF1F4F5);
        badgeTextColor = const Color(0xFF4B5563);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFF009191);
      backgroundColor = const Color(0xFFE9F7F7);
      textColor = const Color(0xFF0F766E);
      badgeColor = const Color(0xFF009191);
      badgeTextColor = Colors.white;
    } else {
      borderColor = const Color(0xFFE3E8EF);
      backgroundColor = Colors.white;
      textColor = const Color(0xFF1D204B);
      badgeColor = const Color(0xFFF1F4F5);
      badgeTextColor = const Color(0xFF4B5563);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    option.letter,
                    style: TextStyle(
                      color: badgeTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),
              ?trailingIcon,
            ],
          ),
        ),
      ),
    );
  }
}
