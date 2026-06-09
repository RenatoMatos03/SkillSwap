import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import '../../models/forum/question.dart';
import '../../services/forum_service.dart';
import 'custom_badge.dart';

/// Cartão de curso para listagem no fórum com contagem de perguntas em tempo real.
class CourseCard extends StatefulWidget {
  final Course course;
  final VoidCallback onTap;

  const CourseCard({super.key, required this.course, required this.onTap});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16.0);
    final hoverColor = Colors.grey.withValues(alpha: 0.05);
    final splashColor = widget.course.color.withValues(alpha: 0.1);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
        alignment: FractionalOffset.center,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 15 : 10,
              spreadRadius: _isHovered ? 1 : 0,
              offset: _isHovered ? const Offset(0, 5) : const Offset(0, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              hoverColor: hoverColor,
              splashColor: splashColor,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      color: widget.course.color,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: widget.course.color.withValues(alpha: 0.3), width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                widget.course.acronym.substring(0, 2),
                                style: TextStyle(color: widget.course.color, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.course.acronym,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B)),
                                      ),
                                      const SizedBox(width: 8),
                                      CustomBadge(
                                        text: widget.course.type,
                                        textColor: const Color(0xFF009191),
                                        bgColor: const Color(0xFFE0F2F1),
                                        icon: Icons.school,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.course.name,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1D204B)),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      StreamBuilder<List<Question>>(
                                        stream: ForumService().getQuestionsStream(widget.course.acronym),
                                        builder: (context, snapshot) {
                                          int count = snapshot.hasData ? snapshot.data!.length : 0;
                                          return Text(
                                            "$count perguntas",
                                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      CustomBadge(
                                        text: widget.course.area,
                                        textColor: widget.course.color,
                                        bgColor: widget.course.color.withValues(alpha: 0.1),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Colors.grey)
                          ],
                        ),
                      ),
                    ),
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
