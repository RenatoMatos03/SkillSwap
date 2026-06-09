import 'package:flutter/material.dart';
import '../../models/forum/school.dart';
import '../../models/forum/course.dart'; // <--- NOVO IMPORT
import '../../services/forum_service.dart'; // <--- NOVO IMPORT

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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
                blurRadius: _isHovered ? 15 : 10,
                offset: _isHovered ? const Offset(0, 5) : const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.school.icon, size: 40, color: const Color(0xFF1D204B)),
              const SizedBox(height: 12),
              Text(widget.school.acronym, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1D204B))),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.school.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              
              StreamBuilder<List<Course>>(
                stream: ForumService().getCoursesStream(widget.school.acronym),
                builder: (context, snapshot) {
                  // Conta quantos cursos chegaram do Firebase
                  int count = snapshot.hasData ? snapshot.data!.length : 0;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$count cursos",
                      style: const TextStyle(color: Color(0xFF009191), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}