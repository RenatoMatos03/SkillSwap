// lib/screens/match_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchPage extends StatefulWidget {
  final String phoneNumber;

  const MatchPage({super.key, required this.phoneNumber});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  void initState() {
    super.initState();
    // Assim que a página abre, começa a contar o tempo para abrir o WhatsApp
    _openWhatsAppAfterDelay();
  }

  // Espera 2 segundos (para o utilizador ler "Ligação criada!") e abre o WhatsApp
  Future<void> _openWhatsAppAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    //Remove os espaços e o sinal de "+" se existirem na base de dados
    String cleanNumber = widget.phoneNumber
        .replaceAll('+', '')
        .replaceAll(' ', '');

    final Uri whatsappUrl = Uri.parse("https://wa.me/$cleanNumber");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF009191),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de Check com borda circular
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 24),

            // Texto Principal
            const Text(
              "Ligação criada!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Subtítulo
            Text(
              "A abrir mensagens...",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
