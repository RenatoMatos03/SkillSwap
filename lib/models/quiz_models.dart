/// Opção de resposta de uma pergunta do quiz.
class QuizOption {
  final String letter;
  final String text;
  final bool isCorrect;

  const QuizOption({
    required this.letter,
    required this.text,
    required this.isCorrect,
  });
}

/// Pergunta do quiz com categoria, enunciado e lista de opções.
class QuizQuestion {
  final String category;
  final String prompt;
  final List<QuizOption> options;

  const QuizQuestion({
    required this.category,
    required this.prompt,
    required this.options,
  });
}
