import 'package:flutter/material.dart';

import 'quiz_models.dart';
import 'quiz_question_page.dart';

class QuizHomeView extends StatelessWidget {
  const QuizHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF009191),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.emoji_events, size: 42, color: Colors.white),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'QUIZ SEMANAL',
                style: TextStyle(
                  color: Color(0xFF009191),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Bases de Dados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D204B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Semana 21 · 04 de Maio 2026',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 26),
            Row(
              children: const [
                Expanded(child: _QuizStatCard(icon: Icons.timer_outlined, value: '10 min', label: 'Duração')),
                SizedBox(width: 10),
                Expanded(child: _QuizStatCard(icon: Icons.quiz_outlined, value: '10', label: 'Questões')),
                SizedBox(width: 10),
                Expanded(child: _QuizStatCard(icon: Icons.signal_cellular_alt, value: '1-10', label: 'Nível')),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Testa os teus conhecimentos sobre SQL,\nnormalização, transações e modelação de bases de dados.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF5F6368), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizQuestionPage(questions: sampleQuizQuestions),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009191),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Iniciar Quiz',
                  style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '10 questões · 1 ponto por resposta certa',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _QuizStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF009191), size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1D204B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}