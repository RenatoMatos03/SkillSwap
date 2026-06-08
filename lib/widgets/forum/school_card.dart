import 'package:flutter/material.dart';
import '../../models/forum/school.dart';
import 'custom_badge.dart';

class SchoolCard extends StatefulWidget {
  final School school;
  final VoidCallback onTap;

  const SchoolCard({super.key, required this.school, required this.onTap});

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Definimos o raio dos cantos aqui para reutilizar
    final borderRadius = BorderRadius.circular(20.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 15 : 10,
              spreadRadius: _isHovered ? 4 : 2,
              offset: _isHovered ? const Offset(0, 8) : const Offset(0, 0),
            )
          ],
        ),
        // A SOLUÇÃO ESTÁ AQUI: ClipRRect obriga o clique a não sair dos cantos!
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            color: Colors.transparent, 
            child: InkWell(
              onTap: widget.onTap,
              // Cores de clique e hover muito mais suaves e integradas
              hoverColor: Colors.grey.withOpacity(0.05),
              splashColor: const Color(0xFF009191).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Icon(widget.school.icon, size: 40, color: Colors.grey[700]),
                    const SizedBox(height: 12),
                    Text(
                      widget.school.acronym,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1D204B)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.school.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    CustomBadge(
                      text: "${widget.school.coursesCount} cursos",
                      textColor: const Color(0xFF009191),
                      bgColor: const Color(0xFFE0F2F1),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}