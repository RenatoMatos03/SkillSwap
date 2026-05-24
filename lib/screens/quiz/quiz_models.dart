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

const List<QuizQuestion> sampleQuizQuestions = [
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'O que é uma chave primária numa base de dados relacional?',
    options: [
      QuizOption(letter: 'A', text: 'Um campo que identifica unicamente cada registo', isCorrect: true),
      QuizOption(letter: 'B', text: 'Um campo que pode ter valores nulos', isCorrect: false),
      QuizOption(letter: 'C', text: 'Um índice de pesquisa rápida', isCorrect: false),
      QuizOption(letter: 'D', text: 'Uma relação entre duas tabelas', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Qual destas afirmações descreve melhor uma chave estrangeira?',
    options: [
      QuizOption(letter: 'A', text: 'Identifica unicamente uma tabela', isCorrect: false),
      QuizOption(letter: 'B', text: 'Liga um registo a outra tabela', isCorrect: true),
      QuizOption(letter: 'C', text: 'Guarda apenas números inteiros', isCorrect: false),
      QuizOption(letter: 'D', text: 'É sempre auto incrementada', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Em SQL, que comando é usado para consultar dados?',
    options: [
      QuizOption(letter: 'A', text: 'INSERT', isCorrect: false),
      QuizOption(letter: 'B', text: 'UPDATE', isCorrect: false),
      QuizOption(letter: 'C', text: 'SELECT', isCorrect: true),
      QuizOption(letter: 'D', text: 'DELETE', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'O que significa a normalização de uma base de dados?',
    options: [
      QuizOption(letter: 'A', text: 'Duplicar tabelas para ganhar performance', isCorrect: false),
      QuizOption(letter: 'B', text: 'Organizar os dados para reduzir redundância', isCorrect: true),
      QuizOption(letter: 'C', text: 'Eliminar todas as chaves', isCorrect: false),
      QuizOption(letter: 'D', text: 'Criar apenas uma tabela', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Qual é a função de um índice numa tabela?',
    options: [
      QuizOption(letter: 'A', text: 'Acelerar a pesquisa de registos', isCorrect: true),
      QuizOption(letter: 'B', text: 'Guardar palavras-passe', isCorrect: false),
      QuizOption(letter: 'C', text: 'Substituir a chave primária', isCorrect: false),
      QuizOption(letter: 'D', text: 'Bloquear a tabela para leitura', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Qual comando remove uma tabela inteira?',
    options: [
      QuizOption(letter: 'A', text: 'DROP TABLE', isCorrect: true),
      QuizOption(letter: 'B', text: 'DELETE TABLE', isCorrect: false),
      QuizOption(letter: 'C', text: 'REMOVE TABLE', isCorrect: false),
      QuizOption(letter: 'D', text: 'CLEAR TABLE', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'O que é uma transação em base de dados?',
    options: [
      QuizOption(letter: 'A', text: 'Um conjunto de operações executadas como uma unidade', isCorrect: true),
      QuizOption(letter: 'B', text: 'Um tipo de tabela temporária', isCorrect: false),
      QuizOption(letter: 'C', text: 'Um comando de consulta', isCorrect: false),
      QuizOption(letter: 'D', text: 'Uma cópia da base de dados', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Qual é o propósito da cláusula WHERE?',
    options: [
      QuizOption(letter: 'A', text: 'Ordenar os resultados', isCorrect: false),
      QuizOption(letter: 'B', text: 'Filtrar linhas com base numa condição', isCorrect: true),
      QuizOption(letter: 'C', text: 'Juntar tabelas', isCorrect: false),
      QuizOption(letter: 'D', text: 'Criar um índice', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'O comando JOIN serve para:',
    options: [
      QuizOption(letter: 'A', text: 'Combinar dados de duas ou mais tabelas', isCorrect: true),
      QuizOption(letter: 'B', text: 'Apagar colunas', isCorrect: false),
      QuizOption(letter: 'C', text: 'Criar uma nova base de dados', isCorrect: false),
      QuizOption(letter: 'D', text: 'Contar o número de registos', isCorrect: false),
    ],
  ),
  QuizQuestion(
    category: 'Bases de Dados',
    prompt: 'Qual destas opções é uma forma de integridade referencial?',
    options: [
      QuizOption(letter: 'A', text: 'Permitir valores duplicados numa chave primária', isCorrect: false),
      QuizOption(letter: 'B', text: 'Garantir relações válidas entre tabelas', isCorrect: true),
      QuizOption(letter: 'C', text: 'Eliminar restrições de chaves', isCorrect: false),
      QuizOption(letter: 'D', text: 'Usar apenas valores nulos', isCorrect: false),
    ],
  ),
];