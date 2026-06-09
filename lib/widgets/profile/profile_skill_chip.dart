import 'package:flutter/material.dart';
import '../../theme/app_tokens.dart';

/// Chip de skill para apresentar uma competência no perfil.
class ProfileSkillChip extends StatelessWidget {
  final String label;

  const ProfileSkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceMint,
        border: Border.all(color: AppColors.chipBorder),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
