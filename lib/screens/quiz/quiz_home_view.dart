import 'package:flutter/material.dart';

import '../../models/quiz_models.dart';
import 'quiz_question_page.dart';
import '../../services/quiz_service.dart';
import '../../widgets/quiz/quiz_widgets.dart';

class QuizHomeView extends StatefulWidget {
  const QuizHomeView({super.key});

  @override
  State<QuizHomeView> createState() => _QuizHomeViewState();
}

class _QuizHomeViewState extends State<QuizHomeView> {
  final _quizService = QuizService();

  List<QuizQuestion>? _questions;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final questions = await _quizService.fetchQuestions();
      if (mounted) setState(() => _questions = questions);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              'Informática',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D204B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Perguntas sobre Computação e Tecnologia',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 26),
            const Row(
              children: [
                Expanded(child: QuizStatCard(icon: Icons.quiz_outlined, value: '10', label: 'Questões')),
                SizedBox(width: 10),
                Expanded(child: QuizStatCard(icon: Icons.monetization_on_outlined, value: '10', label: 'Coins')),
                SizedBox(width: 10),
                Expanded(child: QuizStatCard(icon: Icons.signal_cellular_alt, value: 'Misto', label: 'Nível')),
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Testa os teus conhecimentos sobre programação,\nredes, bases de dados e sistemas operativos.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF5F6368), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 28),
            if (_error != null) ...[
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _error != null
                        ? _loadQuestions
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuizQuestionPage(questions: _questions!),
                              ),
                            );
                          },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009191),
                  disabledBackgroundColor: const Color(0xFFD6DBE0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        _error != null ? 'Tentar novamente' : 'Iniciar Quiz',
                        style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '10 questões · 1 coin por resposta certa',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
