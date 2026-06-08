import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import 'widgets_forum.dart';

class QuestionFullBody extends StatelessWidget {
  final Question question;

  const QuestionFullBody({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D204B), height: 1.3),
        ),
        const SizedBox(height: 12),
        if (question.tags.isNotEmpty) 
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: question.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF2F5F7), borderRadius: BorderRadius.circular(6)),
              child: Text("#$tag", style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            )).toList(),
          ),
        const SizedBox(height: 16),
        // A descrição não tem limites de linhas (maxLines), logo ocupa o espaço que precisar
        Text(
          question.description,
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 14, color: Color(0xFF4F4F4F), height: 1.6),
        ),
        const SizedBox(height: 20),
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
        ),
      ],
    );
  }
}