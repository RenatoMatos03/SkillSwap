import 'package:flutter/material.dart';

import '../../widgets/quiz/quiz_widgets.dart';

class QuizResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final incorrect = totalQuestions - score;
    final percent = totalQuestions == 0 ? 0.0 : score / totalQuestions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Resultado',
          style: TextStyle(
            color: Color(0xFF1D204B),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1D204B)),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: const Color(0xFF009191),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF009191).withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 28,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events, color: Colors.amber, size: 26),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 7),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '$score/$totalQuestions',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Boa prestação! 🎉',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '+ $score coins ganhas',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: QuizResultStatCard(
                      value: '${(percent * 100).round()}%',
                      label: 'Precisão',
                      valueColor: const Color(0xFF009191),
                      backgroundColor: const Color(0xFFEAF7F6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: QuizResultStatCard(
                      value: '$incorrect',
                      label: 'Erradas',
                      valueColor: const Color(0xFFE25555),
                      backgroundColor: const Color(0xFFFFF5F5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DETALHES',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              QuizResultDetailRow(
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF009191),
                label: 'Respostas corretas',
                value: '$score',
              ),
              QuizResultDetailRow(
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFFE25555),
                label: 'Respostas incorretas',
                value: '$incorrect',
              ),
              QuizResultDetailRow(
                icon: Icons.emoji_events_outlined,
                iconColor: const Color(0xFFF59E0B),
                label: 'Coins ganhas',
                value: '+$score',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009191),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Voltar ao início',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
