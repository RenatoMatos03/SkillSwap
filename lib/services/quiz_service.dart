import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/quiz_models.dart';

/// Serviço que obtém e processa perguntas do quiz a partir da Open Trivia Database.
class QuizService {
  static const _apiUrl =
    'https://opentdb.com/api.php?amount=10&category=18&type=multiple';

  /// Obtém 10 perguntas de informática e devolve-as formatadas.
  Future<List<QuizQuestion>> fetchQuestions() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode != 200) {
      throw Exception('Erro de rede. Verifica a tua ligação.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final responseCode = data['response_code'] as int;

    if (responseCode != 0) {
      throw Exception('Não foi possível obter perguntas. Tenta mais tarde.');
    }

    final results = data['results'] as List;
    return results.map((q) => _mapQuestion(q as Map<String, dynamic>)).toList();
  }

  /// Converte um resultado da API numa [QuizQuestion] com opções baralhas.
  QuizQuestion _mapQuestion(Map<String, dynamic> q) {
    final correctAnswer = _decode(q['correct_answer'] as String);
    final incorrectAnswers =
      (q['incorrect_answers'] as List).map((a) => _decode(a as String)).toList();

    final allAnswers = [correctAnswer, ...incorrectAnswers]..shuffle(Random());
    final letters = ['A', 'B', 'C', 'D'];

    final options = List.generate(
      allAnswers.length,
      (i) => QuizOption(
        letter: letters[i],
        text: allAnswers[i],
        isCorrect: allAnswers[i] == correctAnswer,
      ),
    );

    return QuizQuestion(
      category: _decode(q['category'] as String),
      prompt: _decode(q['question'] as String),
      options: options,
    );
  }

  /// Descodifica entidades HTML presentes nas respostas da API.
  String _decode(String text) {
    return text
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&ldquo;', '"')
      .replaceAll('&rdquo;', '"')
      .replaceAll('&lsquo;', "'")
      .replaceAll('&rsquo;', "'")
      .replaceAll('&hellip;', '...')
      .replaceAll('&eacute;', 'é')
      .replaceAll('&agrave;', 'à')
      .replaceAll('&ntilde;', 'ñ')
      .replaceAll('&ouml;', 'ö')
      .replaceAll('&uuml;', 'ü')
      .replaceAll('&auml;', 'ä');
  }
}
