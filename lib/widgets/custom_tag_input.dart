import 'package:flutter/material.dart';

class CustomTagInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onAdd;

  const CustomTagInputField({
    super.key,
    required this.controller,
    required this.onAdd,
    this.hintText = "Adicionar tag...",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onAdd(),
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(12),
            hoverColor: const Color(0xFF007979),
            child: Ink(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF009191),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTagChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const CustomTagChip({super.key, required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFB2DFDB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, size: 14, color: Color(0xFF009191)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF009191), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}