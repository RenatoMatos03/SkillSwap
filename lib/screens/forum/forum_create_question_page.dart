import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import '../../widgets/forum/widgets_forum.dart';
import '../../widgets/widgets.dart'; // Para os AuthButton e custom tags se estiverem aqui

class ForumCreateQuestionPage extends StatefulWidget {
  const ForumCreateQuestionPage({super.key});

  @override
  State<ForumCreateQuestionPage> createState() => _ForumCreateQuestionPageState();
}

class _ForumCreateQuestionPageState extends State<ForumCreateQuestionPage> {
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  final List<String> _tags = [];
  final List<Map<String, dynamic>> _attachments = []; // Lista vazia para simular anexos
  bool _isAnonymous = false;

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
      setState(() {
        _tags.add(tag.trim());
      });
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  // Simula a adição de um anexo ao clicar nos botões
  void _addMockAttachment(String type) {
    setState(() {
      if (type == 'Imagem') {
        _attachments.add({"icon": Icons.image, "color": Colors.teal, "title": "captura_ecra.png", "subtitle": "PNG · 800 KB"});
      } else if (type == 'Ficheiro') {
        _attachments.add({"icon": Icons.picture_as_pdf, "color": Colors.redAccent, "title": "documento_apoio.pdf", "subtitle": "PDF · 1.5 MB"});
      } else if (type == 'Código') {
        _attachments.add({"icon": Icons.code, "color": Colors.blueGrey, "title": "script.sql", "subtitle": "SQL · 12 KB"});
      }
    });
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _publishQuestion() {
    // Validação simples
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preenche o título e a descrição.", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
      return;
    }

    // Cria a nova pergunta
    final newQuestion = Question(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      status: "Aberta",
      userName: _isAnonymous ? "Anónimo" : "Maria Rodrigues", // Simula o utilizador atual
      userInitials: _isAnonymous ? "A" : "MR",
      userCourse: _isAnonymous ? "Anónimo" : "LEIC",
      commentsCount: 0,
      timeAgo: "agora",
      tags: List.from(_tags),
    );

    // Devolve a pergunta para a página anterior
    Navigator.pop(context, newQuestion);
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
            
            CustomTagInputField(
              controller: _tagController,
              hintText: "Ex: Base de Dados...",
              onAdd: _addTag,
            ),
            const SizedBox(height: 16),
            
            if (_tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) => CustomTagChip(
                  label: tag,
                  onRemove: () => _removeTag(tag),
                )).toList(),
              ),
            
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
              onChanged: (text) => setState(() {}), // Para atualizar o contador
              decoration: InputDecoration(
                hintText: "Qual é a tua dúvida? (sê específico)",
                counterText: "",
                filled: true,
                fillColor: const Color(0xFFF2F5F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            const Text("DESCRIÇÃO", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Descreve o teu problema em detalhe, inclui o que já tentaste...",
                filled: true,
                fillColor: const Color(0xFFF2F5F7),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isAnonymous,
                    activeColor: const Color(0xFF009191),
                    onChanged: (val) {
                      setState(() => _isAnonymous = val ?? false);
                    },
                  ),
                ),
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
            const SizedBox(height: 24),

            const Text("ANEXOS (OPCIONAL)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(onTap: () => _addMockAttachment('Imagem'), child: _buildAttachmentButton(Icons.image, "Imagem")),
                const SizedBox(width: 8),
                GestureDetector(onTap: () => _addMockAttachment('Ficheiro'), child: _buildAttachmentButton(Icons.attach_file, "Ficheiro")),
                const SizedBox(width: 8),
                GestureDetector(onTap: () => _addMockAttachment('Código'), child: _buildAttachmentButton(Icons.code, "Código")),
              ],
            ),
            const SizedBox(height: 16),
            
            // Desenha a lista de anexos dinamicamente se existirem
            ..._attachments.asMap().entries.map((entry) {
              int idx = entry.key;
              var att = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: AttachedFileCard(
                  icon: att["icon"],
                  iconColor: att["color"],
                  title: att["title"],
                  subtitle: att["subtitle"],
                  trailingWidget: GestureDetector(
                    onTap: () => _removeAttachment(idx),
                    child: const Icon(Icons.close, size: 18, color: Colors.grey),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 40),

            AuthButton(
              text: "Publicar Pergunta",
              onPressed: _publishQuestion, // Chama a nossa função de publicar!
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

  Widget _buildAttachmentButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}