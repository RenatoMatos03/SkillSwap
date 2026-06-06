import 'package:flutter/material.dart';
import 'top_right_actions.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ForumAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: const [TopRightActions()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}