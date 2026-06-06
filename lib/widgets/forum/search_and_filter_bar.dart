import 'package:flutter/material.dart';

class SearchAndFilterBar extends StatelessWidget {
  final String hintText;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onChanged; // <--- ADICIONADO PARA REATIVIDADE

  const SearchAndFilterBar({
    super.key, 
    required this.hintText, 
    required this.onFilterTap,
    this.onChanged, // <--- ADICIONADO
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged, // <--- LIGADO AQUI
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onFilterTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.tune, size: 18),
                SizedBox(width: 8),
                Text("Filtrar"),
              ],
            ),
          ),
        )
      ],
    );
  }
}