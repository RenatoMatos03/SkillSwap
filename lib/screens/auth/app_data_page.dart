import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../widgets/widgets.dart';
import '../home/home_page.dart';

class AppDataPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final String school;
  final String course;
  final String academicYear;

  const AppDataPage({
    super.key,
    required this.name,
    required this.birthDate,
    required this.school,
    required this.course,
    required this.academicYear,
  });

  @override
  State<AppDataPage> createState() => _AppDataPageState();
}

class _AppDataPageState extends State<AppDataPage> {
  final _userService = UserService();
  bool _isLoading = false;

  final List<String> _tagsProcura = [];
  final List<String> _tagsOferta = [];

  final TextEditingController _procuraController = TextEditingController();
  final TextEditingController _ofertaController = TextEditingController();

  void _addTag(TextEditingController controller, List<String> lista) {
    if (controller.text.isNotEmpty) {
      setState(() {
        lista.add(controller.text);
        controller.clear();
      });
    }
  }

  void _removeTag(String tag, List<String> lista) {
    setState(() {
      lista.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: _buildProgressStep(true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildProgressStep(true)),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("PASSO 2 DE 2", style: TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                const Text("Dados da Aplicação", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D204B))),
                const SizedBox(height: 8),
                const Text("Define as tuas áreas de interesse e as que podes ensinar.", style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: 25),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFB2DFDB), width: 0.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Colors.orangeAccent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 12, color: Color(0xFF00796B), height: 1.4),
                            children: [
                              TextSpan(text: "As "),
                              TextSpan(text: "Tags de Procura", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " definem o que queres aprender. As "),
                              TextSpan(text: "Tags de Oferta", style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: " definem o que podes ensinar."),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                AuthCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTagSection("Tags de Procura", "O que queres aprender?", _procuraController, _tagsProcura),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(color: Color(0xFFF1F4F5)),
                      ),
                      _buildTagSection("Tags de Oferta", "O que podes ensinar?", _ofertaController, _tagsOferta),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                AuthButton(
                  text: _isLoading ? "A guardar..." : "Finalizar ✓",
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    try {
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final email = FirebaseAuth.instance.currentUser!.email!;
                      final profile = UserProfile(
                        uid: uid,
                        email: email,
                        name: widget.name,
                        birthDate: widget.birthDate,
                        school: widget.school,
                        course: widget.course,
                        academicYear: widget.academicYear,
                        tagsProcura: _tagsProcura,
                        tagsOferta: _tagsOferta,
                      );
                      await _userService.saveUserProfile(profile);
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                ),
                
                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("← Voltar", style: TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(bool active) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF009191) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildTagSection(String title, String subtitle, TextEditingController controller, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Procurar tag...",
                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _addTag(controller, tags),
                borderRadius: BorderRadius.circular(12),
                hoverColor: const Color(0xFF007979),
                child: Ink(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF009191),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) => _buildChip(tag, tags)).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String label, List<String> lista) {
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFB2DFDB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _removeTag(label, lista),
              child: const Icon(Icons.close, size: 14, color: Color(0xFF009191)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF009191), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}