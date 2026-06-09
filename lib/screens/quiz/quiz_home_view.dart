import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/quiz_models.dart';
import '../../services/quiz_service.dart';
import '../../services/user_service.dart';
import '../../widgets/quiz/quiz_widgets.dart';
import 'quiz_question_page.dart';

/// Vista inicial do quiz semanal com estado de bloqueio baseado na semana atual.
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

  /// Obtém as perguntas do quiz a partir da API.
  Future<void> _loadQuestions() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final questions = await _quizService.fetchQuestions();
      if (mounted) setState(() => _questions = questions);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int get _daysUntilNextMonday => 8 - DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: uid != null
          ? FirebaseFirestore.instance.collection('users').doc(uid).snapshots()
          : const Stream.empty(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final lastQuizWeek = data?['lastQuizWeek'] ?? '';
        final isLocked = lastQuizWeek == UserService.currentWeekKey();

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
                    color: isLocked
                        ? Colors.grey.shade300
                        : const Color(0xFF009191),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    isLocked ? Icons.lock_outline : Icons.emoji_events,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLocked
                        ? Colors.grey.shade100
                        : const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'QUIZ SEMANAL',
                    style: TextStyle(
                      color: isLocked
                          ? Colors.grey
                          : const Color(0xFF009191),
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
                if (isLocked) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            color: Color(0xFF009191), size: 28),
                        const SizedBox(height: 8),
                        const Text(
                          'Quiz da semana concluído!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF1D204B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Próximo quiz disponível em $_daysUntilNextMonday ${_daysUntilNextMonday == 1 ? 'dia' : 'dias'}',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Testa os teus conhecimentos sobre programação,\nredes, bases de dados e sistemas operativos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF5F6368), fontSize: 14, height: 1.5),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13)),
                  ],
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLocked
                        ? null
                        : _isLoading
                            ? null
                            : _error != null
                                ? _loadQuestions
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizQuestionPage(
                                            questions: _questions!),
                                      ),
                                    );
                                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLocked
                          ? Colors.grey.shade300
                          : const Color(0xFF009191),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: isLocked
                        ? const Text(
                            'Volta na próxima semana',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                _error != null
                                    ? 'Tentar novamente'
                                    : 'Iniciar Quiz',
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
      },
    );
  }
}
