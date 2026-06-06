import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class AboutUsContentCard extends StatelessWidget {
  const AboutUsContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F6F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/skill_swap_logo.png'),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SkillSwap',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D204B),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A plataforma de aprendizagem entre pares',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'v1.0 - Protótipo IPM 2026',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.dividerLight, thickness: 1),
          const SizedBox(height: 14),
          const Text(
            'Sobre a Aplicação',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D204B),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'O SkillSwap é uma plataforma académica colaborativa desenvolvida para estudantes universitários. O nosso objetivo é promover a interação entre alunos através de um sistema de micro-recompensas virtuais, fóruns organizados por cadeiras, matchmaking inteligente e sessões de mentoria entre pares. Acreditamos que o conhecimento partilhado tem mais valor.',
            style: TextStyle(height: 1.45, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FeatureChip(label: 'Matchmaking'),
              _FeatureChip(label: 'Moedas Virtuais'),
              _FeatureChip(label: 'Fórum por Cadeira'),
              _FeatureChip(label: 'Quiz Semanal'),
              _FeatureChip(label: 'Streaks'),
              _FeatureChip(label: 'Leaderboard'),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'A Nossa Equipa',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D204B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Equipa multidisciplinar de estudantes do IPM — design, desenvolvimento e educação. Se quiseres colaborar ou saber mais sobre o projeto, contacta-nos através do e-mail institucional.',
            style: TextStyle(height: 1.45, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.chipBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
