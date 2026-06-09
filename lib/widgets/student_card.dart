import 'package:flutter/material.dart';
import '../models/user_profile.dart';

/// Cartão de perfil de estudante exibido no ecrã de swipe.
class StudentCard extends StatelessWidget {
  final UserProfile profile;

  const StudentCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    String dominaText = profile.tagsOferta.isNotEmpty
        ? profile.tagsOferta.join(', ')
        : 'Ainda não definiu';

    String precisaText = profile.tagsProcura.isNotEmpty
        ? profile.tagsProcura.join(', ')
        : 'Ainda não definiu';

    return Stack(
      children: [
        Positioned.fill(
          child: profile.photoUrl.isNotEmpty
              ? Image.network(
                  profile.photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildNoImage(),
                )
              : _buildNoImage(),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
              ),
            ),
          ),
        ),

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
                          profile.rating.toStringAsFixed(1),
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
                "${profile.course} - ${profile.academicYear}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DOMINA: ",
                    style: TextStyle(
                      color: Color(0xFF009191),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      dominaText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PRECISA: ",
                    style: TextStyle(
                      color: Color(0xFF009191),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      precisaText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoImage() {
    return Container(
      color: Colors.grey[800],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Colors.white54),
            SizedBox(height: 8),
            Text("Sem Imagem", style: TextStyle(color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}
