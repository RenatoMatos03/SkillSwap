import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/profile/profile_widgets.dart';

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
  final _bioController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();
  final _courseController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _tagOfertaController = TextEditingController();
  final _tagProcuraController = TextEditingController();

  late List<String> _tagsOferta;
  late List<String> _tagsProcura;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bioController.text = widget.profile.bio;
    _photoUrlController.text = widget.profile.photoUrl;
    _phoneController.text = widget.profile.phoneNumber;
    _schoolController.text = widget.profile.school;
    _courseController.text = widget.profile.course;
    _academicYearController.text = widget.profile.academicYear;
    _tagsOferta = List.from(widget.profile.tagsOferta);
    _tagsProcura = List.from(widget.profile.tagsProcura);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _photoUrlController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _courseController.dispose();
    _academicYearController.dispose();
    _tagOfertaController.dispose();
    _tagProcuraController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _userService.updateProfile(
        uid: widget.profile.uid,
        bio: _bioController.text.trim(),
        photoUrl: _photoUrlController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        school: _schoolController.text.trim(),
        course: _courseController.text.trim(),
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

  void _removeTag(List<String> list, String tag) {
    setState(() => list.remove(tag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
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
            _buildBioSection(),
            const SizedBox(height: 24),
            _buildTagsSection(
              title: 'Domina',
              subtitle: 'Áreas em que podes ajudar outros',
              tags: _tagsOferta,
              controller: _tagOfertaController,
              hintText: 'Ex: Cálculo, POO...',
              onAdd: () => _addTag(_tagsOferta, _tagOfertaController),
              onRemove: (tag) => _removeTag(_tagsOferta, tag),
            ),
            const SizedBox(height: 24),
            _buildTagsSection(
              title: 'À Procura de Ajuda',
              subtitle: 'Áreas em que precisas de apoio',
              tags: _tagsProcura,
              controller: _tagProcuraController,
              hintText: 'Ex: Análise, SQL...',
              onAdd: () => _addTag(_tagsProcura, _tagProcuraController),
              onRemove: (tag) => _removeTag(_tagsProcura, tag),
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
            child: _buildTextField(
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
          _buildLabeledField(
            label: 'Telemóvel',
            controller: _phoneController,
            hint: 'Ex: +351 912 345 678',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            label: 'Escola',
            controller: _schoolController,
            hint: 'Ex: IPS',
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            label: 'Curso',
            controller: _courseController,
            hint: 'Ex: Licenciatura em Engenharia Informática',
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            label: 'Ano',
            controller: _academicYearController,
            hint: 'Ex: 2º Ano',
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        _buildTextField(controller: controller, hint: hint, keyboardType: keyboardType),
      ],
    );
  }

  Widget _buildBioSection() {
    return ProfileSectionCard(
      title: 'Sobre Mim',
      child: TextField(
        controller: _bioController,
        maxLines: 4,
        maxLength: 300,
        decoration: _inputDecoration('Escreve algo sobre ti...'),
      ),
    );
  }

  Widget _buildTagsSection({
    required String title,
    required String subtitle,
    required List<String> tags,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onAdd,
    required void Function(String) onRemove,
  }) {
    return ProfileSectionCard(
      title: title,
      subtitle: subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map(
                    (tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      backgroundColor: AppColors.surfaceMint,
                      side: const BorderSide(color: AppColors.chipBorder),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      onDeleted: () => onRemove(tag),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller,
                  hint: hintText,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      filled: true,
      fillColor: AppColors.pageBackground,
    );
  }

}
