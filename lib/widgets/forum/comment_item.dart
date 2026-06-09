import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';
import 'custom_badge.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final Function(CommentModel) onReply;
  final bool showAcceptButton; // <--- A NOVA VARIÁVEL LIMPA
  final VoidCallback onSolutionToggled;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onReply,
    required this.showAcceptButton,
    required this.onSolutionToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: comment.isSolution ? const Color(0xFFF2FCF3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: comment.isSolution ? const Color(0xFF00E676) : Colors.grey.withOpacity(0.2),
          width: comment.isSolution ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: const Color(0xFF009191), child: Text(comment.userInitials, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D204B))),
              const SizedBox(width: 8),
              CustomBadge(text: comment.badge, textColor: const Color(0xFF009191), bgColor: const Color(0xFFE0F2F1)),
              const Spacer(),
              Text("há ${comment.timeAgo}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(comment.text, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 13, color: Color(0xFF4F4F4F), height: 1.5)),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [const Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey), const SizedBox(width: 4), Text("${comment.votes}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1D204B))), const SizedBox(width: 4), const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey)]),
              ),
              const SizedBox(width: 16),
              
              GestureDetector(
                onTap: () => onReply(comment),
                child: const Row(children: [Icon(Icons.reply, size: 16, color: Colors.grey), SizedBox(width: 4), Text("Responder", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))]),
              ),
              const Spacer(),
              
              if (comment.isSolution)
                const Row(children: [Icon(Icons.check, size: 16, color: Color(0xFF00E676)), SizedBox(width: 4), Text("Solução Aceite", style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12))])
              else if (showAcceptButton) // <--- USA A VARIÁVEL AQUI
                TextButton(
                  onPressed: onSolutionToggled, 
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text("✔ Aceitar Solução", style: TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold, fontSize: 12)),
                )
            ],
          ),
        ],
      ),
    );
  }
}