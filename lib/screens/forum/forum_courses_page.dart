import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import '../../widgets/forum/widgets_forum.dart';
import 'forum_questions_page.dart';

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

  final List<Course> _allCourses = [
    Course(acronym: "LEIC", name: "Licenciatura em Engenharia Informática e de Computadores", type: "Licenciatura", subjectsCount: 28, area: "Informática", color: const Color(0xFF00BFA5)),
    Course(acronym: "LSIRC", name: "Licenciatura em Segurança Informática em Redes e...", type: "Licenciatura", subjectsCount: 24, area: "Segurança", color: const Color(0xFF651FFF)),
    Course(acronym: "LEI", name: "Licenciatura em Engenharia Eletrotécnica e de Computadores", type: "Licenciatura", subjectsCount: 26, area: "Eletrotécnica", color: const Color(0xFFFF9100)),
    Course(acronym: "LME", name: "Licenciatura em Engenharia Mecânica", type: "Licenciatura", subjectsCount: 22, area: "Mecânica", color: const Color(0xFF00E676)),
  ];

  List<Course> _displayedCourses = [];

  @override
  void initState() {
    super.initState();
    _displayedCourses = List.from(_allCourses);
  }

  void _applyFilters() {
    List<Course> filtered = _allCourses.where((course) {
      final searchLower = _searchQuery.toLowerCase();
      return course.name.toLowerCase().contains(searchLower) ||
             course.acronym.toLowerCase().contains(searchLower);
    }).toList();

    if (_selectedOrder == "Alfabético A-Z") {
      filtered.sort((a, b) => a.acronym.compareTo(b.acronym));
    } else if (_selectedOrder == "Alfabético Z-A") {
      filtered.sort((a, b) => b.acronym.compareTo(a.acronym));
    } else if (_selectedOrder == "+ Cadeiras") {
      filtered.sort((a, b) => b.subjectsCount.compareTo(a.subjectsCount));
    } else if (_selectedOrder == "- Cadeiras") {
      filtered.sort((a, b) => a.subjectsCount.compareTo(b.subjectsCount));
    }

    if (_selectedGroup == "Tipo de curso") {
      filtered.sort((a, b) => a.type.compareTo(b.type));
    } else if (_selectedGroup == "Área temática") {
      filtered.sort((a, b) => a.area.compareTo(b.area));
    }

    setState(() {
      _displayedCourses = filtered;
    });
  }

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
        _applyFilters();
      },
      onClear: () {
        setState(() {
          _selectedOrder = "Padrão";
          _selectedGroup = "Sem agrupamento";
        });
        _applyFilters();
        Navigator.pop(context);
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
                  FilterChipWidget(label: "+ Cadeiras", isSelected: tempOrder == "+ Cadeiras", onTap: () => setModalState(() => tempOrder = "+ Cadeiras")),
                  FilterChipWidget(label: "- Cadeiras", isSelected: tempOrder == "- Cadeiras", onTap: () => setModalState(() => tempOrder = "- Cadeiras")),
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
            ForumPageHeader(title: widget.schoolName), // Cabeçalho fixado no body
            SearchAndFilterBar(
              hintText: "Pesquisar curso...",
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
                const Text("Todos os Cursos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${_displayedCourses.length} cursos", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _displayedCourses.isEmpty 
              ? const Center(child: Text("Nenhum curso encontrado.", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _displayedCourses.length,
                  itemBuilder: (context, index) => CourseCard(
                    course: _displayedCourses[index], 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForumQuestionsPage(subjectName: _displayedCourses[index].acronym),
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