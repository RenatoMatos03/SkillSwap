import 'package:flutter/material.dart';
import '../models/swipe/student_profile.dart';

class StudentCard extends StatelessWidget {
  final StudentProfile profile;

  const StudentCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagem de Fundo
        Positioned.fill(
          child: Image.asset(
            profile.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: Text(
                  "Sem Imagem",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        // Gradiente Escuro
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ],
              ),
            ),
          ),
        ),

        // Informação do Aluno
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children:
                    List.generate(5, (index) {
                      return Icon(
                        index < profile.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    })..add(
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          profile.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                profile.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile.course,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "DOMINA: ",
                    style: TextStyle(
                      color: Color(0xFF009191),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    profile.domina,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    "PRECISA: ",
                    style: TextStyle(
                      color: Color(0xFF009191),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    profile.precisa,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
