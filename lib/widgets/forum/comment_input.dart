import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';

/// Campo de entrada de comentário ou resposta, com indicação do comentário ao qual se responde.
class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final CommentModel? replyingTo;
  final VoidCallback onCancelReply;
  final VoidCallback onSubmit;

  const CommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.replyingTo,
    required this.onCancelReply,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingTo != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                color: const Color(0xFFE0F2F1),
                child: Row(
                  children: [
                    const Icon(Icons.reply, size: 14, color: Color(0xFF009191)),
                    const SizedBox(width: 8),
                    Text(
                      "A responder a ${replyingTo!.userName}",
                      style: const TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold, fontSize: 12)
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onCancelReply,
                      child: const Icon(Icons.close, size: 16, color: Color(0xFF009191)),
                    )
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: replyingTo != null ? "Escreve uma resposta..." : "Escreve um comentário na pergunta...",
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF2F5F7),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFF009191), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: onSubmit,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
