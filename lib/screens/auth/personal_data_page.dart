import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import '../../models/forum/school.dart';
import '../../services/forum_service.dart';
import '../../widgets/widgets.dart';
import 'app_data_page.dart';

/// Ecrã do passo 1 do registo para recolha de dados pessoais e académicos.
class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _forumService = ForumService();

  String? _selectedYear;

  List<School> _schools = [];
  List<Course> _courses = [];
  School? _selectedSchool;
  Course? _selectedCourse;
  bool _loadingSchools = true;
  bool _loadingCourses = false;
  DateTime? _selectedDate;

  static const _primary = Color(0xFF009191);
  static const _fieldColor = Color(0xFFF2F5F7);

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadSchools() async {
    final schools = await _forumService.getSchoolsStream().first;
    if (mounted) setState(() { _schools = schools; _loadingSchools = false; });
  }

  /// Carrega os cursos da escola selecionada e reinicia o curso escolhido.
  Future<void> _onSchoolSelected(School school) async {
    setState(() {
      _selectedSchool = school;
      _selectedCourse = null;
      _loadingCourses = true;
      _courses = [];
    });
    final courses = await _forumService.getCoursesStream(school.acronym).first;
    if (mounted) setState(() { _courses = courses; _loadingCourses = false; });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: _primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String get _formattedDate {
    if (_selectedDate == null) return '';
    final d = _selectedDate!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildProgressBar(),
              const SizedBox(height: 30),
              const Text("PASSO 1 DE 2",
                  style: TextStyle(
                      color: _primary, fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 8),
              const Text("Dados Pessoais",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D204B))),
              const SizedBox(height: 8),
              const Text("Preenche as informações do teu perfil académico.",
                  style: TextStyle(color: Colors.grey, fontSize: 15)),
              const SizedBox(height: 30),
              AuthCard(
                child: Column(
                  children: [
                    AuthTextField(
                      label: "Nome",
                      hintText: "Renato Matos",
                      controller: _nameController,
                    ),
                    const SizedBox(height: 20),
                    _buildDatePicker(),
                    const SizedBox(height: 20),
                    PhoneInputField(controller: _phoneController),
                    const SizedBox(height: 20),
                    SearchableDropdown<School>(
                      label: 'Escola',
                      options: _schools,
                      display: (s) => s.name,
                      subtitle: (s) => s.acronym,
                      onSelected: _onSchoolSelected,
                      onCleared: () => setState(() => _selectedSchool = null),
                      hint: _loadingSchools ? 'A carregar...' : 'Pesquisar escola...',
                      loading: _loadingSchools,
                      isSelected: _selectedSchool != null,
                    ),
                    const SizedBox(height: 20),
                    SearchableDropdown<Course>(
                      label: 'Curso',
                      options: _courses,
                      display: (c) => c.name,
                      subtitle: (c) => c.acronym,
                      onSelected: (c) => setState(() => _selectedCourse = c),
                      onCleared: () => setState(() => _selectedCourse = null),
                      hint: _selectedSchool == null
                          ? 'Seleciona primeiro a escola'
                          : 'Pesquisar curso...',
                      enabled: _selectedSchool != null,
                      loading: _loadingCourses,
                      isSelected: _selectedCourse != null,
                    ),
                    const SizedBox(height: 20),
                    AcademicYearDropdown(
                      label: 'Ano Escolar',
                      value: _selectedYear,
                      onChanged: (y) => setState(() => _selectedYear = y),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildNextButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() => Row(
    children: [
      Expanded(child: _progressSegment(true)),
      const SizedBox(width: 8),
      Expanded(child: _progressSegment(false)),
    ],
  );

  Widget _progressSegment(bool active) => Container(
    height: 4,
    decoration: BoxDecoration(
      color: active ? _primary : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(2),
    ),
  );

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Data de Nascimento',
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _fieldColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  _selectedDate == null ? 'Selecionar data' : _formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (_nameController.text.trim().isEmpty ||
              _selectedDate == null ||
              _selectedSchool == null ||
              _selectedCourse == null ||
              _selectedYear == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Preenche todos os campos obrigatórios.')));
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppDataPage(
                name: _nameController.text.trim(),
                birthDate: _selectedDate!,
                school: _selectedSchool!.name,
                course: _selectedCourse!.name,
                academicYear: _selectedYear!,
                phoneNumber: '+351${_phoneController.text.trim()}',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Avançar ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
