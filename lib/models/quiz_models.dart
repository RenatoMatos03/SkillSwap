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
