import 'package:flutter/material.dart';

import 'quiz_models.dart';
import 'quiz_result_page.dart';

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
      if (_selectedOptionIndex == null) {
        return;
      }

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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFE6EAEE)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4F5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'PERGUNTA $currentQuestionNumber',
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentQuestion.prompt,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D204B),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2F1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _currentQuestion.category,
                              style: const TextStyle(
                                color: Color(0xFF009191),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...List.generate(_currentQuestion.options.length, (index) {
                      final option = _currentQuestion.options[index];
                      final bool isSelected = _selectedOptionIndex == index;
                      final bool isCorrect = option.isCorrect;
                      final bool showAnsweredState = _answered;

                      Color borderColor = const Color(0xFFE3E8EF);
                      Color backgroundColor = Colors.white;
                      Color textColor = const Color(0xFF1D204B);
                      Color badgeColor = const Color(0xFFF1F4F5);
                      Color badgeTextColor = const Color(0xFF4B5563);
                      Widget? trailingIcon;

                      if (showAnsweredState) {
                        if (isCorrect) {
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
                          textColor = const Color(0xFF98A2B3);
                        }
                      } else if (isSelected) {
                        borderColor = const Color(0xFF009191);
                        backgroundColor = const Color(0xFFE9F7F7);
                        textColor = const Color(0xFF0F766E);
                        badgeColor = const Color(0xFF009191);
                        badgeTextColor = Colors.white;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _answered ? null : () => setState(() => _selectedOptionIndex = index),
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
                                if (trailingIcon != null) trailingIcon,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_answered) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                              ? const Color(0xFFE6F7F6)
                              : const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                                ? const Color(0xFF009191)
                                : const Color(0xFFE25555),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                                  ? Icons.check_circle_outline
                                  : Icons.error_outline,
                              color: _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                                  ? const Color(0xFF009191)
                                  : const Color(0xFFE25555),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                                    ? 'Correto! Muito bem.'
                                    : 'Incorreto. A resposta correta é a opção ${_currentQuestion.options.firstWhere((option) => option.isCorrect).letter}.',
                                style: TextStyle(
                                  color: _currentQuestion.options[_selectedOptionIndex ?? 0].isCorrect
                                      ? const Color(0xFF005B5B)
                                      : const Color(0xFFB42318),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                    _answered ? 'Próxima Pergunta +' : 'Confirmar Resposta',
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