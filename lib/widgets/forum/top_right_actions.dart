import 'package:flutter/material.dart';

class TopRightActions extends StatelessWidget {
  const TopRightActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.copyright, size: 16, color: Color(0xFF009191)),
              SizedBox(width: 4),
              Text("100 €", style: TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF009191),
          child: Text("MR", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}