import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import '../../models/forum/school.dart';
import '../../models/user_profile.dart';
import '../../services/forum_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/profile/profile_widgets.dart';
import '../../widgets/widgets.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onSaved;

  const EditProfilePage({
    super.key,
    required this.profile,
    required this.onSaved,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _userService = UserService();
  final _forumService = ForumService();

  final _bioController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _phoneController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _tagOfertaController = TextEditingController();
  final _tagProcuraController = TextEditingController();

  List<School> _schools = [];
  List<Course> _courses = [];
  School? _selectedSchool;
  Course? _selectedCourse;
  bool _loadingSchools = true;
  bool _loadingCourses = false;

  late List<String> _tagsOferta;
  late List<String> _tagsProcura;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _bioController.text = p.bio;
    _photoUrlController.text = p.photoUrl;
    _academicYearController.text = p.academicYear;
    _tagsOferta = List.from(p.tagsOferta);
    _tagsProcura = List.from(p.tagsProcura);

    final phone = p.phoneNumber;
    _phoneController.text =
        phone.startsWith('+351') ? phone.substring(4) : phone;

    _loadSchools();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _photoUrlController.dispose();
    _phoneController.dispose();
    _academicYearController.dispose();
    _tagOfertaController.dispose();
    _tagProcuraController.dispose();
    super.dispose();
  }

  Future<void> _loadSchools() async {
    final schools = await _forumService.getSchoolsStream().first;
    if (!mounted) return;
    final idx = schools.indexWhere((s) => s.name == widget.profile.school);
    final matched = idx >= 0 ? schools[idx] : null;
    setState(() {
      _schools = schools;
      _selectedSchool = matched;
      _loadingSchools = false;
    });
    if (matched != null) await _loadCourses(matched);
  }

  Future<void> _loadCourses(School school) async {
    setState(() { _loadingCourses = true; _courses = []; });
    final courses = await _forumService.getCoursesStream(school.acronym).first;
    if (!mounted) return;
    final idx = courses.indexWhere((c) => c.name == widget.profile.course);
    setState(() {
      _courses = courses;
      _selectedCourse = idx >= 0 ? courses[idx] : null;
      _loadingCourses = false;
    });
  }

  Future<void> _onSchoolSelected(School school) async {
    setState(() {
      _selectedSchool = school;
      _selectedCourse = null;
    });
    await _loadCourses(school);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _userService.updateProfile(
        uid: widget.profile.uid,
        bio: _bioController.text.trim(),
        photoUrl: _photoUrlController.text.trim(),
        phoneNumber: '+351${_phoneController.text.trim()}',
        school: _selectedSchool?.name ?? widget.profile.school,
        course: _selectedCourse?.name ?? widget.profile.course,
        academicYear: _academicYearController.text.trim(),
        tagsOferta: _tagsOferta,
        tagsProcura: _tagsProcura,
      );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addTag(List<String> list, TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty || list.contains(value)) return;
    setState(() => list.add(value));
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Editar Perfil',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text('Guardar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            ProfileSectionCard(
              title: 'Sobre Mim',
              child: LabeledTextField(
                controller: _bioController,
                hint: 'Escreve algo sobre ti...',
                maxLines: 4,
                maxLength: 300,
              ),
            ),
            const SizedBox(height: 24),
            EditTagsSection(
              title: 'Domina',
              subtitle: 'Áreas em que podes ajudar outros',
              tags: _tagsOferta,
              controller: _tagOfertaController,
              hintText: 'Ex: Cálculo, POO...',
              onAdd: () => _addTag(_tagsOferta, _tagOfertaController),
              onRemove: (tag) => setState(() => _tagsOferta.remove(tag)),
            ),
            const SizedBox(height: 24),
            EditTagsSection(
              title: 'À Procura de Ajuda',
              subtitle: 'Áreas em que precisas de apoio',
              tags: _tagsProcura,
              controller: _tagProcuraController,
              hintText: 'Ex: Análise, SQL...',
              onAdd: () => _addTag(_tagsProcura, _tagProcuraController),
              onRemove: (tag) => setState(() => _tagsProcura.remove(tag)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return ProfileSectionCard(
      title: 'Foto de Perfil',
      subtitle: 'Cola o URL de uma imagem pública',
      child: Row(
        children: [
          ProfileAvatar(
            name: widget.profile.name,
            photoUrl: _photoUrlController.text.trim(),
            radius: 36,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: LabeledTextField(
              controller: _photoUrlController,
              hint: 'https://...',
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return ProfileSectionCard(
      title: 'Informação Pessoal',
      child: Column(
        children: [
          PhoneInputField(controller: _phoneController),
          const SizedBox(height: 16),
          SearchableDropdown<School>(
            label: 'Escola',
            options: _schools,
            display: (s) => s.name,
            subtitle: (s) => s.acronym,
            onSelected: _onSchoolSelected,
            onCleared: () => setState(() => _selectedSchool = null),
            hint: 'Pesquisar escola...',
            loading: _loadingSchools,
            isSelected: _selectedSchool != null,
            initialValue: widget.profile.school,
          ),
          const SizedBox(height: 16),
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
            initialValue: widget.profile.course,
          ),
          const SizedBox(height: 16),
          LabeledTextField(
            label: 'Ano',
            controller: _academicYearController,
            hint: 'Ex: 2º Ano',
          ),
        ],
      ),
    );
  }
}
