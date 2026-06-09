import 'package:flutter/material.dart';
import '../widgets.dart'; 

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ForumAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0, // <-- Remove o efeito cinzento no scroll
      surfaceTintColor: Colors.transparent, // <-- Garante que o fundo fica sempre puro
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: const [
        // AQUI: Removido o parâmetro "value"
        AppBalanceChip(), 
        SizedBox(width: 8),
        AppUserAvatar(initials: 'MR'),
        SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}