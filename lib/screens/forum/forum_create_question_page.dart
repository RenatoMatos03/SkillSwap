import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/forum/question.dart';
import '../../services/forum_service.dart';
import '../../services/user_service.dart';
import '../../widgets/forum/widgets_forum.dart';
import '../../widgets/widgets.dart';
import '../../utils/utils.dart'; // <--- O TEU NOVO IMPORT LIMPO

class ForumCreateQuestionPage extends StatefulWidget {
  final String subjectName; 

  const ForumCreateQuestionPage({super.key, required this.subjectName});

  @override
  State<ForumCreateQuestionPage> createState() => _ForumCreateQuestionPageState();
}

class _ForumCreateQuestionPageState extends State<ForumCreateQuestionPage> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  final List<String> _tags = [];
  bool _isAnonymous = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences(); // Carrega a preferência ao abrir
  }

  // NOVO MÉTODO
  Future<void> _loadUserPreferences() async {
    final profile = await UserService().getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _isAnonymous = profile.defaultAnonymousMode;
      });
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text;
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() => _tags.add(tag.trim()));
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _confirmPublish() {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preenche o título e a descrição."), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => CustomConfirmationDialog(
        title: "Publicar Pergunta?",
        content: "Tens a certeza que queres publicar esta pergunta?\n\nSerão descontadas 2 moedas do teu saldo.",
        onConfirm: _executePublish, 
      ),
    );
  }

  Future<void> _executePublish() async {
    setState(() => _isLoading = true);

    try {
      final profile = await UserService().getUserProfile();
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      
      final newQuestion = Question(
        userId: uid,
        subjectName: widget.subjectName,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        status: "Aberta",
        userName: _isAnonymous ? "Anónimo" : (profile?.name ?? "Utilizador"),
        userInitials: _isAnonymous ? "A" : (profile != null ? getInitials(profile.name) : "U"),
        userCourse: _isAnonymous ? "Anónimo" : (profile?.course ?? "IPS"),
        commentsCount: 0,
        createdAt: DateTime.now(), 
        tags: List.from(_tags),
      );

      await ForumService().createQuestion(newQuestion);
      
      if (uid.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'coins': FieldValue.increment(-2) 
        });
      }
      
      if (mounted) {
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ForumPageHeader(title: "Nova Pergunta"),

            const Text("TAGS DA PERGUNTA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            CustomTagInputField(controller: _tagController, hintText: "Ex: Base de Dados...", onAdd: _addTag),
            const SizedBox(height: 16),
            
            if (_tags.isNotEmpty)
              Wrap(spacing: 8, runSpacing: 8, children: _tags.map((tag) => CustomTagChip(label: tag, onRemove: () => _removeTag(tag))).toList()),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TÍTULO / PERGUNTA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("${_titleController.text.length}/120", style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              maxLength: 120,
              onChanged: (_) => setState(() {}), 
              decoration: InputDecoration(hintText: "Qual é a tua dúvida?", counterText: "", filled: true, fillColor: const Color(0xFFF2F5F7), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 24),

            const Text("DESCRIÇÃO", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 6,
              decoration: InputDecoration(hintText: "Descreve o teu problema em detalhe...", filled: true, fillColor: const Color(0xFFF2F5F7), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(width: 24, height: 24, child: Checkbox(value: _isAnonymous, activeColor: const Color(0xFF009191), onChanged: (val) => setState(() => _isAnonymous = val ?? false))),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Publicar anonimamente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("O teu nome não será visível para os outros utilizadores.", style: TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),

            AuthButton(
              text: _isLoading ? "A publicar..." : "Publicar Pergunta",
              onPressed: _isLoading ? null : _confirmPublish, 
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 30.0),
                child: Text("custa 2 moedas", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}