import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import '../../services/forum_service.dart';
import '../../widgets/forum/widgets_forum.dart';
import 'forum_questions_page.dart';

/// Ecrã de listagem dos cursos de uma escola com pesquisa, filtros e agrupamento.
class ForumCoursesPage extends StatefulWidget {
  final String schoolName;

  const ForumCoursesPage({super.key, required this.schoolName});

  @override
  State<ForumCoursesPage> createState() => _ForumCoursesPageState();
}

class _ForumCoursesPageState extends State<ForumCoursesPage> {
  String _searchQuery = "";
  String _selectedOrder = "Padrão";
  String _selectedGroup = "Sem agrupamento";

  /// Abre o diálogo de filtros e aplica as opções selecionadas.
  void _showFilterModal(BuildContext context) {
    String tempOrder = _selectedOrder;
    String tempGroup = _selectedGroup;

    showTopFilterDialog(
      context: context,
      title: "Filtros e Ordenação",
      applyButtonText: "Aplicar",
      onApply: () {
        setState(() {
          _selectedOrder = tempOrder;
          _selectedGroup = tempGroup;
        });
      },
      onClear: () {
        setState(() {
          _selectedOrder = "Padrão";
          _selectedGroup = "Sem agrupamento";
        });
      },
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FilterSectionTitle("ORDENAR POR"),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: [
                  FilterChipWidget(label: "Padrão", isSelected: tempOrder == "Padrão", onTap: () => setModalState(() => tempOrder = "Padrão")),
                  FilterChipWidget(label: "Alfabético A-Z", isSelected: tempOrder == "Alfabético A-Z", onTap: () => setModalState(() => tempOrder = "Alfabético A-Z")),
                  FilterChipWidget(label: "Alfabético Z-A", isSelected: tempOrder == "Alfabético Z-A", onTap: () => setModalState(() => tempOrder = "Alfabético Z-A")),
                  FilterChipWidget(label: "+ Perguntas", isSelected: tempOrder == "+ Perguntas", onTap: () => setModalState(() => tempOrder = "+ Perguntas")),
                  FilterChipWidget(label: "- Perguntas", isSelected: tempOrder == "- Perguntas", onTap: () => setModalState(() => tempOrder = "- Perguntas")),
                ],
              ),
              const SizedBox(height: 24),
              const FilterSectionTitle("AGRUPAR POR"),
              FilterRadioOption(label: "Sem agrupamento", isSelected: tempGroup == "Sem agrupamento", onTap: () => setModalState(() => tempGroup = "Sem agrupamento")),
              FilterRadioOption(label: "Tipo de curso", isSelected: tempGroup == "Tipo de curso", onTap: () => setModalState(() => tempGroup = "Tipo de curso")),
              FilterRadioOption(label: "Área temática", isSelected: tempGroup == "Área temática", onTap: () => setModalState(() => tempGroup = "Área temática")),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ForumPageHeader(title: widget.schoolName),
            SearchAndFilterBar(
              hintText: "Pesquisar curso...",
              onFilterTap: () => _showFilterModal(context),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Course>>(
                stream: ForumService().getCoursesStream(widget.schoolName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF009191)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Nenhum curso encontrado nesta escola.", style: TextStyle(color: Colors.grey))
                    );
                  }

                  List<Course> filtered = snapshot.data!.where((course) {
                    final searchLower = _searchQuery.toLowerCase();
                    return course.name.toLowerCase().contains(searchLower) ||
                           course.acronym.toLowerCase().contains(searchLower);
                  }).toList();

                  filtered.sort((a, b) {
                    if (_selectedGroup == "Tipo de curso") {
                      int groupCmp = a.type.compareTo(b.type);
                      if (groupCmp != 0) return groupCmp;
                    } else if (_selectedGroup == "Área temática") {
                      int groupCmp = a.area.compareTo(b.area);
                      if (groupCmp != 0) return groupCmp;
                    }

                    if (_selectedOrder == "Alfabético A-Z") {
                      return a.acronym.compareTo(b.acronym);
                    } else if (_selectedOrder == "Alfabético Z-A") {
                      return b.acronym.compareTo(a.acronym);
                    } else if (_selectedOrder == "+ Perguntas") {
                      int countCmp = b.questionsCount.compareTo(a.questionsCount);
                      if (countCmp != 0) return countCmp;
                      return a.acronym.compareTo(b.acronym);
                    } else if (_selectedOrder == "- Perguntas") {
                      int countCmp = a.questionsCount.compareTo(b.questionsCount);
                      if (countCmp != 0) return countCmp;
                      return a.acronym.compareTo(b.acronym);
                    }

                    return 0;
                  });

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Todos os Cursos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${filtered.length} cursos", style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final course = filtered[index];
                            bool showGroupHeader = false;
                            String groupTitle = "";

                            if (_selectedGroup != "Sem agrupamento") {
                              groupTitle = _selectedGroup == "Tipo de curso" ? course.type : course.area;

                              if (index == 0) {
                                showGroupHeader = true;
                              } else {
                                final prevCourse = filtered[index - 1];
                                final prevGroupTitle = _selectedGroup == "Tipo de curso" ? prevCourse.type : prevCourse.area;
                                if (groupTitle != prevGroupTitle) {
                                  showGroupHeader = true;
                                }
                              }
                            }

                            Widget courseCard = CourseCard(
                              course: course,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ForumQuestionsPage(subjectName: course.acronym)),
                                );
                              },
                            );

                            if (showGroupHeader) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (index > 0) const SizedBox(height: 28),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        groupTitle.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF009191),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF009191).withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  courseCard,
                                ],
                              );
                            }
                            return courseCard;
                          },
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
