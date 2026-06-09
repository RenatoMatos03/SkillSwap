import 'package:flutter/material.dart';

const _kFieldColor = Color(0xFFF2F5F7);

class AcademicYearDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;
  final String? label;

  static const years = [
    '1º Ano', '2º Ano', '3º Ano', '4º Ano', '5º Ano',
  ];

  const AcademicYearDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: _kFieldColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text('Selecionar ano',
                  style: TextStyle(color: Colors.grey)),
              items: years
                  .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
