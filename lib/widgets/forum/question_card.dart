import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import 'custom_badge.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final VoidCallback onTap;

  const QuestionCard({super.key, required this.question, required this.onTap});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isResolved = widget.question.status == "Resolvida";
    final borderRadius = BorderRadius.circular(16.0);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
        alignment: FractionalOffset.center,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: isResolved 
              ? const Color(0xFF009191).withValues(alpha: _isHovered ? 0.6 : 0.3) 
              : Colors.grey.withValues(alpha: _isHovered ? 0.4 : 0.2) // Corrigido
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.06 : 0.02), // Corrigido
              blurRadius: _isHovered ? 12 : 10,
              spreadRadius: _isHovered ? 1 : 0,
              offset: _isHovered ? const Offset(0, 4) : const Offset(0, 0),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              hoverColor: Colors.grey.withValues(alpha: 0.05),
              splashColor: const Color(0xFF009191).withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBadge(
                      text: widget.question.status,
                      textColor: isResolved ? const Color(0xFF009191) : Colors.grey[700]!,
                      bgColor: isResolved ? const Color(0xFFE0F2F1) : Colors.grey[200]!,
                      icon: isResolved ? Icons.check_circle : Icons.circle_outlined,
                    ),
                    const SizedBox(height: 12),
                    Text(widget.question.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B))),
                    const SizedBox(height: 8),
                    Text(widget.question.description, style: TextStyle(fontSize: 13, color: Colors.grey[600]), maxLines: 3, overflow: TextOverflow.ellipsis),
                    
                    if (widget.question.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.question.tags.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F5F7), 
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "#$tag",
                            style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        )).toList(),
                      ),
                    ],

                    const SizedBox(height: 16),
                    Row(
                      children: [
                         CircleAvatar(radius: 12, backgroundColor: const Color(0xFF009191), child: Text(widget.question.userInitials, style: const TextStyle(color: Colors.white, fontSize: 10))),
                         const SizedBox(width: 8),
                         Text(widget.question.userName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                         const Spacer(),
                         Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
                         const SizedBox(width: 4),
                         Text("${widget.question.commentsCount}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                         const SizedBox(width: 12),
                         Text("há ${widget.question.timeAgo}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
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