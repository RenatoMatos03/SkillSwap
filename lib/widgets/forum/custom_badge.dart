import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;
  final IconData? icon;

  const CustomBadge({
    super.key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 12, color: textColor), const SizedBox(width: 4)],
          Text(text, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}