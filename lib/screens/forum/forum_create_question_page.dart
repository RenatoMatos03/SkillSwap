import 'package:flutter/material.dart';
import '../../widgets/forum/widgets_forum.dart';
import '../../widgets/widgets.dart';

class ForumCreateQuestionPage extends StatefulWidget {
  const ForumCreateQuestionPage({super.key});

  @override
  State<ForumCreateQuestionPage> createState() => _ForumCreateQuestionPageState();
}

class _ForumCreateQuestionPageState extends State<ForumCreateQuestionPage> {
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];
  bool _isAnonymous = false;

  void _addTag(String tag) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar REMOVIDO DAQUI
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOVO CABEÇALHO ADICIONADO AQUI
            const ForumPageHeader(title: "Nova Pergunta"),

            const Text("TAGS DA PERGUNTA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._tags.map((tag) => Chip(
                  label: Text(tag, style: const TextStyle(color: Color(0xFF009191), fontSize: 12)),
                  backgroundColor: const Color(0xFFE0F2F1),
                  deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF009191)),
                  onDeleted: () => _removeTag(tag),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
                )),
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _tagController,
                    onSubmitted: _addTag,
                    decoration: InputDecoration(
                      hintText: _tags.isEmpty ? "Ex: Base de Dados..." : "+ Adicionar tag",
                      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF2F5F7),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("TÍTULO / PERGUNTA", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                Text("0/120", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              maxLength: 120,
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Publicar anonimamente", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("O teu nome não será visível para os outros utilizadores.", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            const Text("ANEXOS (OPCIONAL)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildAttachmentButton(Icons.image, "Imagem"),
                const SizedBox(width: 8),
                _buildAttachmentButton(Icons.attach_file, "Ficheiro"),
                const SizedBox(width: 8),
                _buildAttachmentButton(Icons.code, "Código", isSelected: false),
              ],
            ),
            const SizedBox(height: 16),
            
            AttachedFileCard(
              icon: Icons.image,
              iconColor: Colors.teal,
              title: "diagrama_er.png",
              subtitle: "PNG · 1.2 MB",
              trailingWidget: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            AttachedFileCard(
              icon: Icons.picture_as_pdf,
              iconColor: Colors.redAccent,
              title: "Slides_03_Normalizacao.pdf",
              subtitle: "PDF · 2.4 MB",
              trailingWidget: const Icon(Icons.close, size: 18, color: Colors.grey),
            ),
            
            const SizedBox(height: 40),

            AuthButton(
              text: "Publicar Pergunta",
              onPressed: () {},
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

  Widget _buildAttachmentButton(IconData icon, String label, {bool isSelected = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE0F2F1) : Colors.transparent,
        border: Border.all(color: isSelected ? const Color(0xFF009191) : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: isSelected ? const Color(0xFF009191) : Colors.grey),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: isSelected ? const Color(0xFF009191) : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
          if (isSelected) ...[
             const SizedBox(width: 4),
             const Icon(Icons.check, size: 12, color: Color(0xFF009191)),
          ]
        ],
      ),
    );
  }
}