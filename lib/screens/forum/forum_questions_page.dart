import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/forum/question.dart';
import '../../services/forum_service.dart';
import '../../widgets/forum/widgets_forum.dart';
import 'forum_question_details_page.dart';
import 'forum_create_question_page.dart';

/// Ecrã de listagem de perguntas de uma disciplina com pesquisa e filtros.
class ForumQuestionsPage extends StatefulWidget {
  final String subjectName;

  const ForumQuestionsPage({super.key, required this.subjectName});

  @override
  State<ForumQuestionsPage> createState() => _ForumQuestionsPageState();
}

class _ForumQuestionsPageState extends State<ForumQuestionsPage> with SingleTickerProviderStateMixin {
  String _searchQuery = "";
  String _selectedOrder = "Mais Recentes";
  String _selectedState = "Todos";
  String _selectedPub = "Todos";

  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// Abre o diálogo de filtros e aplica as opções selecionadas à listagem.
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
      },
      onClear: () {
        setState(() {
          _selectedOrder = "Mais Recentes";
          _selectedState = "Todos";
          _selectedPub = "Todos";
        });
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
      floatingActionButton: _ForumCreateQuestionFab(
        subjectName: widget.subjectName,
        shakeController: _shakeController,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ForumPageHeader(title: widget.subjectName),
            SearchAndFilterBar(
              hintText: "Pesquisar pergunta...",
              onFilterTap: () => _showFilterModal(context),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<List<Question>>(
                stream: ForumService().getQuestionsStream(widget.subjectName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF009191)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhuma pergunta encontrada.", style: TextStyle(color: Colors.grey)));
                  }

                  List<Question> filtered = snapshot.data!.where((q) {
                    final searchLower = _searchQuery.toLowerCase();
                    bool matchesSearch = q.title.toLowerCase().contains(searchLower) || q.description.toLowerCase().contains(searchLower) || q.tags.any((tag) => tag.toLowerCase().contains(searchLower));
                    bool matchesState = _selectedState == "Todos" || (_selectedState == "Não Resolvidos" && q.status == "Aberta") || (_selectedState == "Resolvidos" && q.status == "Resolvida");
                    bool matchesPub = _selectedPub == "Todos" || (_selectedPub == "Identificado" && q.userName != "Anónimo") || (_selectedPub == "Anónimo" && q.userName == "Anónimo");
                    return matchesSearch && matchesState && matchesPub;
                  }).toList();

                  if (_selectedOrder == "Mais Comentados") filtered.sort((a, b) => b.commentsCount.compareTo(a.commentsCount));

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Perguntas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${filtered.length} perguntas", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 80),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => QuestionCard(
                            question: filtered[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForumQuestionDetailsPage(question: filtered[index])),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Botão flutuante de criação de pergunta com verificação de saldo em tempo real.
class _ForumCreateQuestionFab extends StatelessWidget {
  final String subjectName;
  final AnimationController shakeController;

  const _ForumCreateQuestionFab({
    required this.subjectName,
    required this.shakeController,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: currentUser != null
          ? FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots()
          : const Stream.empty(),
      builder: (context, snapshot) {
        int coins = 0;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          coins = data['coins'] ?? 0;
        }

        bool hasEnoughCoins = coins >= 2;

        return AnimatedBuilder(
          animation: shakeController,
          builder: (context, child) {
            final sineValue = sin(4 * pi * shakeController.value);

            return Transform.translate(
              offset: Offset(sineValue * 8, 0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  height: 65, width: 260,
                  child: FloatingActionButton.extended(
                    backgroundColor: hasEnoughCoins ? const Color(0xFF009191) : Colors.grey[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    onPressed: () async {
                      if (!hasEnoughCoins) {
                        shakeController.forward(from: 0.0);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Não tem moedas suficientes, realize o quiz semanal ou faça uma explicação com alguém"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 4),
                          ),
                        );
                        return;
                      }

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForumCreateQuestionPage(subjectName: subjectName)),
                      );

                      if (result != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pergunta publicada com sucesso! Foram descontadas 2 moedas."), backgroundColor: Colors.teal),
                        );
                      }
                    },
                    icon: Icon(Icons.add_circle_outline, color: hasEnoughCoins ? Colors.white : Colors.white70, size: 28),
                    label: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Fazer uma Pergunta", style: TextStyle(color: hasEnoughCoins ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("custa 2 moedas", style: TextStyle(color: hasEnoughCoins ? Colors.white70 : Colors.white60, fontSize: 11))
                      ]
                    ),
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}
