import 'package:flutter/material.dart';

class ForumPageHeader extends StatelessWidget {
  final String title;

  const ForumPageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                borderRadius: BorderRadius.circular(12)
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D204B)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title, 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D204B)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}