import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import 'widgets_forum.dart';

class QuestionFullBody extends StatelessWidget {
  final Question question; // <--- RECEBE A PERGUNTA AQUI

  const QuestionFullBody({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionHeader(),
        const SizedBox(height: 16),
        _buildQuestionContent(),
      ],
    );
  }

  Widget _buildQuestionHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFF009191),
          // <--- ALTERADO: Iniciais dinâmicas
          child: Text(question.userInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // <--- ALTERADO: Nome de utilizador dinâmico
                  Text(question.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  // <--- ALTERADO: Curso do utilizador dinâmico em vez de LEIC-D
                  CustomBadge(text: question.userCourse, textColor: const Color(0xFF009191), bgColor: const Color(0xFF009191).withOpacity(0.1)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  // <--- ALTERADO: Estado da pergunta dinâmico
                  CustomBadge(
                    text: question.status, 
                    textColor: question.status == "Resolvida" ? const Color(0xFF009191) : Colors.grey[700]!, 
                    bgColor: question.status == "Resolvida" ? const Color(0xFFE0F2F1) : Colors.grey[200]!, 
                    icon: question.status == "Resolvida" ? Icons.check_circle : Icons.circle_outlined
                  ),
                  const SizedBox(width: 8),
                  // <--- ALTERADO: Tempo de publicação dinâmico
                  Text("há ${question.timeAgo}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.title, // <--- ALTERADO: Título dinâmico da pergunta clicada
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D204B)),
        ),
        const SizedBox(height: 16),
        Text(
          question.description, // <--- ALTERADO: Descrição dinâmica da pergunta clicada
          textAlign: TextAlign.justify, 
          style: const TextStyle(
            fontSize: 14, 
            color: Color(0xFF4F4F4F), 
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Icon(Icons.image, size: 50, color: Colors.grey),
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                    child: const Text("diagrama_er_projeto.png", style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: Colors.redAccent),
                        SizedBox(width: 4),
                        CircleAvatar(radius: 4, backgroundColor: Colors.orangeAccent),
                        SizedBox(width: 4),
                        CircleAvatar(radius: 4, backgroundColor: Colors.greenAccent),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text("exemplo_normalizacao.sql", style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "-- Tabela não normalizada (1FN)\nCREATE TABLE Encomenda (\n  IdEncomenda INT,\n  IdProduto INT,\n  NomeProduto VARCHAR(100), -- depende só do IdProduto\n  Quantidade INT,\n  PRIMARY KEY (IdEncomenda, IdProduto)\n);\n\n-- Solução: separar em 2 tabelas?\nCREATE TABLE Produto (\n  IdProduto INT PRIMARY KEY,\n  NomeProduto VARCHAR(100)\n);",
                  style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AttachedFileCard(
          icon: Icons.picture_as_pdf,
          iconColor: Colors.redAccent,
          title: "Slides_03_Normalizacao.pdf",
          subtitle: "PDF · 2.4 MB",
          trailingWidget: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 30),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Ver", style: TextStyle(fontSize: 12, color: Colors.black)),
          ),
        )
      ],
    );
  }
}