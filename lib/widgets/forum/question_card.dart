import 'package:flutter/material.dart';
import '../../models/forum/question.dart';
import 'custom_badge.dart';

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    bool isResolved = question.status == "Resolvida";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isResolved ? const Color(0xFF009191).withOpacity(0.3) : Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBadge(
            text: question.status,
            textColor: isResolved ? const Color(0xFF009191) : Colors.grey[700]!,
            bgColor: isResolved ? const Color(0xFFE0F2F1) : Colors.grey[200]!,
            icon: isResolved ? Icons.check_circle : Icons.circle_outlined,
          ),
          const SizedBox(height: 12),
          Text(question.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B))),
          const SizedBox(height: 8),
          Text(question.description, style: TextStyle(fontSize: 13, color: Colors.grey[600]), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          Row(
            children: [
               CircleAvatar(radius: 12, backgroundColor: const Color(0xFF009191), child: Text(question.userInitials, style: const TextStyle(color: Colors.white, fontSize: 10))),
               const SizedBox(width: 8),
               Text(question.userName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
               const Spacer(),
               Icon(Icons.chat_bubble_outline, size: 14, color: Colors.grey[600]),
               const SizedBox(width: 4),
               Text("${question.commentsCount}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
               const SizedBox(width: 12),
               Text("há ${question.timeAgo}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}