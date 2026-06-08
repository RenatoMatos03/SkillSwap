import 'package:flutter/material.dart';
import '../../models/forum/course.dart';
import 'custom_badge.dart';

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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        // Zoom ligeiramente mais suave (2%) por ser um cartão largo
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        alignment: FractionalOffset.center,
        // O margin deve ficar no AnimatedContainer, fora do InkWell
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 12 : 8,
              spreadRadius: _isHovered ? 2 : 1,
              offset: _isHovered ? const Offset(0, 4) : const Offset(0, 0),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: borderRadius,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Faixa de cor à esquerda
                  Container(
                    width: 6, 
                    decoration: BoxDecoration(
                      color: widget.course.color, 
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16), 
                        bottomLeft: Radius.circular(16)
                      )
                    )
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 45, height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, 
                              border: Border.all(color: widget.course.color.withOpacity(0.3), width: 2)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              widget.course.acronym.substring(0, 2), 
                              style: TextStyle(color: widget.course.color, fontWeight: FontWeight.bold)
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(widget.course.acronym, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(width: 8),
                                    CustomBadge(text: widget.course.type, textColor: const Color(0xFF009191), bgColor: const Color(0xFFE0F2F1), icon: Icons.school),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(widget.course.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text("${widget.course.subjectsCount} cadeiras disponíveis", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                    const SizedBox(width: 8),
                                    CustomBadge(text: widget.course.area, textColor: widget.course.color, bgColor: widget.course.color.withOpacity(0.1)),
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
    );
  }
}