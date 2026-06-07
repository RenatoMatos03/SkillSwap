import 'package:flutter/material.dart';

import '../../models/quiz_models.dart';
import 'quiz_result_page.dart';
import '../../widgets/quiz/quiz_widgets.dart';

class QuizQuestionPage extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizQuestionPage({super.key, required this.questions});

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _answered = false;
  int _score = 0;

  QuizQuestion get _currentQuestion => widget.questions[_currentIndex];

  void _handlePrimaryAction() {
    if (!_answered) {
      if (_selectedOptionIndex == null) return;
      setState(() {
        _answered = true;
        if (_currentQuestion.options[_selectedOptionIndex!].isCorrect) {
          _score += 1;
        }
      });
      return;
    }

    if (_currentIndex == widget.questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultPage(
            score: _score,
            totalQuestions: widget.questions.length,
          ),
        ),
      );
      return;
    }

    setState(() {
      _currentIndex += 1;
      _selectedOptionIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestionNumber = _currentIndex + 1;
    final progress = currentQuestionNumber / widget.questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.close, size: 18, color: Colors.grey),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Quiz Semanal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D204B),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '$currentQuestionNumber/${widget.questions.length}',
                      style: const TextStyle(
                        color: Color(0xFF009191),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  value: progress,
                  backgroundColor: const Color(0xFFF1F4F5),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF009191)),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuizQuestionCard(
                      question: _currentQuestion,
                      questionNumber: currentQuestionNumber,
                    ),
                    const SizedBox(height: 18),
                    ...List.generate(_currentQuestion.options.length, (index) {
                      return QuizOptionCard(
                        option: _currentQuestion.options[index],
                        isSelected: _selectedOptionIndex == index,
                        isAnswered: _answered,
                        onTap: _answered ? null : () => setState(() => _selectedOptionIndex = index),
                      );
                    }),
                    if (_answered) ...[
                      const SizedBox(height: 4),
                      QuizFeedbackBanner(
                        isCorrect: _currentQuestion.options[_selectedOptionIndex!].isCorrect,
                        correctLetter: _currentQuestion.options.firstWhere((o) => o.isCorrect).letter,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _selectedOptionIndex == null && !_answered ? null : _handlePrimaryAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009191),
                    disabledBackgroundColor: const Color(0xFFD6DBE0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _answered
                        ? (_currentIndex == widget.questions.length - 1 ? 'Ver Resultado' : 'Próxima Pergunta')
                        : 'Confirmar Resposta',
                    style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
