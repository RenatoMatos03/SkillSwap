import 'package:flutter/material.dart';

class FilterSectionTitle extends StatelessWidget {
  final String title;
  const FilterSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap; // <--- ADICIONADO

  const FilterChipWidget({super.key, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // <--- ADICIONADO
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF009191) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF009191) : Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.check, size: 14, color: Colors.white)),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[700], fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class FilterRadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap; // <--- ADICIONADO

  const FilterRadioOption({super.key, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // <--- ADICIONADO
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF009191) : Colors.transparent),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF009191) : Colors.black)),
            const Spacer(),
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF009191) : Colors.grey),
          ],
        ),
      ),
    );
  }
}

class FilterCheckOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap; // <--- ADICIONADO

  const FilterCheckOption({super.key, required this.label, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // <--- ADICIONADO
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF009191) : Colors.black)),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF009191)) else const Icon(Icons.circle_outlined, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}