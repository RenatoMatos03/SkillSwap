import 'package:flutter/material.dart';

/// Ecrã de confirmação de match entre dois utilizadores.
class MatchPage extends StatelessWidget {
  final String profileName;

  const MatchPage({super.key, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Color(0xFF009191),
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "Match Confirmado!",
              style: TextStyle(
                color: Color(0xFF009191),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Conectaste-te com $profileName.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009191),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Continuar",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
