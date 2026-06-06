import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';
import 'custom_badge.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final int depth; 
  final ValueChanged<CommentModel> onReply; // Passa o comentário exato para a caixa de texto
  final bool isQuestionOwner; // Sabe se o user atual é o dono
  final VoidCallback? onSolutionToggled; // Notifica quando o estado de solução muda

  const CommentItem({
    super.key,
    required this.comment,
    this.depth = 0,
    required this.onReply,
    required this.isQuestionOwner,
    this.onSolutionToggled,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  int _userVote = 0; // 0 = Nenhum, 1 = Upvote, -1 = Downvote

  void _handleUpvote() {
    setState(() {
      if (_userVote == 1) {
        _userVote = 0; // Remove o upvote
        widget.comment.votes--;
      } else {
        if (_userVote == -1) widget.comment.votes++; // Anula o downvote anterior
        _userVote = 1;
        widget.comment.votes++;
      }
    });
  }

  void _handleDownvote() {
    setState(() {
      if (_userVote == -1) {
        _userVote = 0; // Remove o downvote
        widget.comment.votes++;
      } else {
        if (_userVote == 1) widget.comment.votes--; // Anula o upvote anterior
        _userVote = -1;
        widget.comment.votes--;
      }
    });
  }

  void _toggleSolution() {
    setState(() {
      widget.comment.isSolution = !widget.comment.isSolution;
    });
    if (widget.onSolutionToggled != null) {
      widget.onSolutionToggled!();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget commentBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14, 
              backgroundColor: const Color(0xFF009191).withOpacity(0.2), 
              child: Text(widget.comment.userInitials, style: const TextStyle(color: Color(0xFF009191), fontSize: 10, fontWeight: FontWeight.bold))
            ),
            const SizedBox(width: 8),
            Text(widget.comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 8),
            CustomBadge(text: widget.comment.badge, textColor: const Color(0xFF009191), bgColor: const Color(0xFF009191).withOpacity(0.1)),
            const Spacer(),
            Text(widget.comment.time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          widget.comment.text, 
          textAlign: TextAlign.justify, 
          style: const TextStyle(fontSize: 13, color: Color(0xFF4F4F4F), height: 1.6),
        ),
        const SizedBox(height: 16),
        
        // --- BOTÕES INTERATIVOS ---
        Row(
          children: [
            // Upvote & Downvote
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _userVote == 1 
                      ? const Color(0xFF009191).withOpacity(0.5) 
                      : (_userVote == -1 ? Colors.grey[400]! : Colors.grey[300]!),
                ), 
                borderRadius: BorderRadius.circular(20),
                color: _userVote == 1 
                    ? const Color(0xFF009191).withOpacity(0.05) 
                    : (_userVote == -1 ? Colors.grey[200] : Colors.transparent),
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                    onTap: _handleUpvote, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                      child: Icon(
                        Icons.keyboard_arrow_up, 
                        size: 16, 
                        color: _userVote == 1 ? const Color(0xFF009191) : Colors.grey
                      )
                    ),
                  ),
                  Text(
                    "${widget.comment.votes}", 
                    style: TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: _userVote == 1 ? const Color(0xFF009191) : (_userVote == -1 ? Colors.grey[800] : Colors.black)
                    )
                  ),
                  InkWell(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                    onTap: _handleDownvote, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(
                        Icons.keyboard_arrow_down, 
                        size: 16, 
                        color: _userVote == -1 ? Colors.grey[800] : Colors.grey 
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Responder
            InkWell(
              onTap: () => widget.onReply(widget.comment), 
              borderRadius: BorderRadius.circular(4),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Icon(Icons.reply, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("Responder", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            
            // Marcar Solução (SÓ APARECE SE FOR O DONO E SE FOR COMENTÁRIO PRINCIPAL: depth == 0)
            if (widget.isQuestionOwner && widget.depth == 0)
              InkWell(
                onTap: _toggleSolution, 
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 14, color: widget.comment.isSolution ? const Color(0xFF00BFA5) : Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        widget.comment.isSolution ? "Solução Aceite" : "Marcar Solução", 
                        style: TextStyle(fontSize: 12, color: widget.comment.isSolution ? const Color(0xFF00BFA5) : Colors.grey, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );

    // Recursividade para respostas aninhadas
    Widget nestedReplies = const SizedBox.shrink();
    if (widget.comment.replies.isNotEmpty) {
      nestedReplies = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.comment.replies.map((reply) => CommentItem(
          comment: reply,
          depth: widget.depth + 1, 
          onReply: widget.onReply,
          isQuestionOwner: widget.isQuestionOwner, // Passa a info para os filhos
          onSolutionToggled: widget.onSolutionToggled,
        )).toList(),
      );
    }

    if (widget.depth > 0) {
      return Container(
        margin: const EdgeInsets.only(left: 32.0, top: 16.0),
        decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey[300]!, width: 2))),
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [commentBody, nestedReplies]),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commentBody,
            nestedReplies,
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F4F5)),
          ],
        ),
      );
    }
  }
}