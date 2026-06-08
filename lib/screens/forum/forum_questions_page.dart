import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import '../../widgets/forum/widgets_forum.dart'; 
import 'forum_question_details_page.dart'; 
import 'forum_create_question_page.dart'; 

class ForumQuestionsPage extends StatefulWidget {
  final String subjectName;

  const ForumQuestionsPage({super.key, required this.subjectName});

  @override
  State<ForumQuestionsPage> createState() => _ForumQuestionsPageState();
}

class _ForumQuestionsPageState extends State<ForumQuestionsPage> {
  String _searchQuery = "";
  String _selectedOrder = "Mais Recentes";
  String _selectedState = "Todos";
  String _selectedPub = "Todos";

  // A lista já não é 'final' para podermos adicionar novas perguntas
  List<Question> _allQuestions = [
    Question(
      title: "Como funciona a normalização até à 3FN em bases de dados?", 
      description: "Estou com dificuldades a perceber os passos para normalizar uma tabela da 1FN até à 3FN. O professor explicou na aula mas faltei essa semana.\n\nAlguém consegue explicar de forma clara o que é uma dependência funcional parcial vs uma dependência transitiva? Com um exemplo concreto seria perfeito — já li a documentação toda mas a linguagem é muito densa.\n\nDeixo o diagrama ER do nosso projeto que pode ajudar como contexto, e um bloco de código com a tabela que estou a tentar normalizar.", 
      status: "Aberta", userName: "Maria Rodrigues", userInitials: "MR", commentsCount: 8, timeAgo: "2h", tags: ["Bases de Dados", "Normalização", "3FN"], userCourse: "LEIC"
    ),
    Question(
      title: "Diferença entre INNER JOIN e LEFT JOIN com exemplos?", 
      description: "Já li a documentação mas ainda não consigo distinguir bem os dois tipos de JOIN na prática. Sei que o INNER JOIN traz apenas os registos que fazem match em ambas as tabelas, mas o LEFT JOIN confunde-me quando há valores nulos do lado direito.\n\nPodem dar-me um exemplo simples com duas tabelas (ex: Clientes e Encomendas) para ver como os dados se comportam em cada um dos casos práticos?", 
      status: "Resolvida", userName: "Ana Ferreira", userInitials: "AF", commentsCount: 12, timeAgo: "5h", tags: ["SQL", "Queries", "JOIN"], userCourse: "LSIRC"
    ),
    Question(
      title: "Erro ao criar trigger no MySQL — sintaxe incorreta", 
      description: "Quando tento criar um trigger no Workbench aparece um erro de sintaxe mesmo seguindo o tutorial passo a passo. O erro diz 'Error Code: 1064. You have an error in your SQL syntax near DELIMITER'.\n\nJá tentei mudar o delimitador para // e para \$\$, mas continua a não compilar o bloco BEGIN...END. Alguém já passou por isto e sabe como forçar a aceitação do delimitador?", 
      status: "Aberta", userName: "Anónimo", userInitials: "A", commentsCount: 3, timeAgo: "1d", tags: ["MySQL", "Triggers", "Erro"], userCourse: "Anónimo"
    ),
    Question(
      title: "Como otimizar uma query com múltiplos subqueries?", 
      description: "A minha query demora demasiado tempo a executar (quase 5 segundos). Tenho 3 subqueries aninhados e a tabela principal tem mais de 500 mil registos.\n\nSerá que substituir os subqueries por múltiplos JOINs melhora a performance drasticamente? Ou devo antes considerar criar índices nas colunas de filtro principais? Aceito sugestões de boas práticas para otimização de arquiteturas pesadas.", 
      status: "Resolvida", userName: "João Santos", userInitials: "JS", commentsCount: 15, timeAgo: "2d", tags: ["Otimização", "Performance"], userCourse: "LME"
    ),
  ];

  List<Question> _displayedQuestions = [];

  @override
  void initState() {
    super.initState();
    _displayedQuestions = List.from(_allQuestions);
  }

  void _applyFilters() {
    List<Question> filtered = _allQuestions.where((q) {
      final searchLower = _searchQuery.toLowerCase();
      
      bool matchesSearch = q.title.toLowerCase().contains(searchLower) || 
                           q.description.toLowerCase().contains(searchLower) ||
                           q.tags.any((tag) => tag.toLowerCase().contains(searchLower));
      
      bool matchesState = _selectedState == "Todos" ||
                         (_selectedState == "Não Resolvidos" && q.status == "Aberta") ||
                         (_selectedState == "Resolvidos" && q.status == "Resolvida");

      bool matchesPub = _selectedPub == "Todos" ||
                       (_selectedPub == "Identificado" && q.userName != "Anónimo") ||
                       (_selectedPub == "Anónimo" && q.userName == "Anónimo");

      return matchesSearch && matchesState && matchesPub;
    }).toList();

    if (_selectedOrder == "Mais Comentados") {
      filtered.sort((a, b) => b.commentsCount.compareTo(a.commentsCount));
    } 

    setState(() {
      _displayedQuestions = filtered;
    });
  }

  void _showFilterModal(BuildContext context) {
    String tempOrder = _selectedOrder;
    String tempState = _selectedState;
    String tempPub = _selectedPub;

    showTopFilterDialog(
      context: context,
      title: "Filtros e Ordenação",
      applyButtonText: "Aplicar filtros",
      onApply: () {
        setState(() {
          _selectedOrder = tempOrder;
          _selectedState = tempState;
          _selectedPub = tempPub;
        });
        _applyFilters();
      },
      onClear: () {
        setState(() {
          _selectedOrder = "Mais Recentes";
          _selectedState = "Todos";
          _selectedPub = "Todos";
        });
        _applyFilters();
        Navigator.pop(context);
      },
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterSectionTitle("ORDENAÇÃO"),
              FilterRadioOption(label: "Mais Recentes", isSelected: tempOrder == "Mais Recentes", onTap: () => setModalState(() => tempOrder = "Mais Recentes")),
              FilterRadioOption(label: "Mais Comentados", isSelected: tempOrder == "Mais Comentados", onTap: () => setModalState(() => tempOrder = "Mais Comentados")),
              const SizedBox(height: 20),
              
              const FilterSectionTitle("ESTADO"),
              FilterRadioOption(label: "Todos", isSelected: tempState == "Todos", onTap: () => setModalState(() => tempState = "Todos")),
              FilterRadioOption(label: "Não Resolvidos", isSelected: tempState == "Não Resolvidos", onTap: () => setModalState(() => tempState = "Não Resolvidos")),
              FilterRadioOption(label: "Resolvidos", isSelected: tempState == "Resolvidos", onTap: () => setModalState(() => tempState = "Resolvidos")),
              const SizedBox(height: 20),
              
              const FilterSectionTitle("PUBLICAÇÃO"),
              FilterRadioOption(label: "Todos", isSelected: tempPub == "Todos", onTap: () => setModalState(() => tempPub = "Todos")),
              FilterRadioOption(label: "Identificado", isSelected: tempPub == "Identificado", onTap: () => setModalState(() => tempPub = "Identificado")),
              FilterRadioOption(label: "Anónimo", isSelected: tempPub == "Anónimo", onTap: () => setModalState(() => tempPub = "Anónimo")),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0), 
        child: SizedBox(
          height: 65, 
          width: 260, 
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF009191),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            // AQUI ESTÁ A MÁGICA DE ESPERAR PELA NOVA PERGUNTA
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForumCreateQuestionPage()),
              );
              
              // Se a página de criação devolver uma pergunta, adiciona-a!
              if (result != null && result is Question) {
                setState(() {
                  _allQuestions.insert(0, result); // Coloca no topo
                  _applyFilters(); // Atualiza a lista no ecrã
                });
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pergunta publicada com sucesso!"), backgroundColor: Colors.teal),
                  );
                }
              }
            },
            icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28), 
            label: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [ 
                Text("Fazer uma Pergunta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), 
                Text("custa 2 moedas", style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ForumPageHeader(title: widget.subjectName),

            SearchAndFilterBar(
              hintText: "Pesquisar pergunta...", 
              onFilterTap: () => _showFilterModal(context),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Perguntas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${_displayedQuestions.length} perguntas", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _displayedQuestions.isEmpty
              ? const Center(child: Text("Nenhuma pergunta encontrada.", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), 
                  itemCount: _displayedQuestions.length,
                  itemBuilder: (context, index) => QuestionCard(
                    question: _displayedQuestions[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumQuestionDetailsPage(question: _displayedQuestions[index]),
                        ),
                      );
                    },
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}