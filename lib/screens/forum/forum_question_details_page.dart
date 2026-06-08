import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';
import '../../models/forum/question.dart';
import '../../widgets/forum/widgets_forum.dart';

class ForumQuestionDetailsPage extends StatefulWidget {
  final Question question;

  const ForumQuestionDetailsPage({super.key, required this.question});

  @override
  State<ForumQuestionDetailsPage> createState() => _ForumQuestionDetailsPageState();
}

class _ForumQuestionDetailsPageState extends State<ForumQuestionDetailsPage> {
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  
  bool _isQuestionOwner = true; 
  bool _sortDescending = true;  
  CommentModel? _replyingTo;    

  @override
  void initState() {
    super.initState();
    _sortComments();
  }

  void _sortComments() {
    _commentsTree.sort((a, b) {
      if (a.isSolution && !b.isSolution) return -1;
      if (!a.isSolution && b.isSolution) return 1;
      return _sortDescending 
          ? b.votes.compareTo(a.votes) 
          : a.votes.compareTo(b.votes);
    });
  }

  final List<CommentModel> _commentsTree = [
    CommentModel(
      id: "1", userName: "Ana Ferreira", userInitials: "AF", badge: "LSIRC", time: "há 2h", votes: 12, isSolution: true,
      text: "Para normalizar até à 3FN, segue estes 3 passos: 1FN — Todos os atributos devem ser atómicos, sem grupos repetitivos nem tabelas dentro de tabelas. 2FN — Elimina dependências parciais; cada atributo não-chave deve depender da chave primária completa. 3FN — Elimina dependências transitivas.",
      replies: [
        CommentModel(
          id: "1.1", userName: "Miguel Ramos", userInitials: "MR", badge: "LEIC", time: "há 2h", votes: 3,
          text: "Obrigado Ana! Ficou muito mais claro com o exemplo da tabela Encomenda.",
          replies: []
        ),
      ],
    ),
    CommentModel(
      id: "2", userName: "João Costa", userInitials: "JC", badge: "LME", time: "há 4h", votes: 8,
      text: "Complementando o que a Ana disse, uma forma de memorizar é o 'juramento': cada atributo não-chave deve depender da chave, toda a chave, e nada mais que a chave.",
    ),
  ];

  @override
  void dispose() {
    _commentFocusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _focusInputForReply(CommentModel comment) {
    setState(() {
      _replyingTo = comment;
    });
    _commentFocusNode.requestFocus();
  }

  void _toggleSort() {
    setState(() {
      _sortDescending = !_sortDescending;
      _sortComments();
    });
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: "Tu (Eu)",
      userInitials: "TU",
      badge: "LEIC",
      time: "agora",
      votes: 0,
      text: text,
      isSolution: false,
      replies: [],
    );

    setState(() {
      if (_replyingTo != null) {
        _replyingTo!.replies.add(newComment);
      } else {
        _commentsTree.add(newComment);
        _sortComments();
      }
      _commentController.clear();
      _replyingTo = null;
    });
    
    _commentFocusNode.unfocus();
  }

  // Novo cabeçalho que coloca o Autor na zona do título
  Widget _buildAuthorHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100], 
                borderRadius: BorderRadius.circular(12)
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D204B)),
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF009191),
            child: Text(widget.question.userInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.question.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    CustomBadge(
                      text: widget.question.userCourse, 
                      textColor: const Color(0xFF009191), 
                      bgColor: const Color(0xFF009191).withOpacity(0.1)
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    CustomBadge(
                      text: widget.question.status, 
                      textColor: widget.question.status == "Resolvida" ? const Color(0xFF009191) : Colors.grey[700]!, 
                      bgColor: widget.question.status == "Resolvida" ? const Color(0xFFE0F2F1) : Colors.grey[200]!, 
                      icon: widget.question.status == "Resolvida" ? Icons.check_circle : Icons.circle_outlined
                    ),
                    const SizedBox(width: 8),
                    Text("há ${widget.question.timeAgo}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildAuthorHeader(),

                QuestionFullBody(question: widget.question),
                
                const SizedBox(height: 32),
                _buildCommentsHeader(),
                const SizedBox(height: 16),
                
                ..._commentsTree.map((comment) => CommentItem(
                  comment: comment,
                  onReply: _focusInputForReply,
                  isQuestionOwner: _isQuestionOwner,
                  onSolutionToggled: () {
                    setState(() {
                      _sortComments();
                    });
                  },
                )),
              ],
            ),
          ),
          CommentInput(
            controller: _commentController,
            focusNode: _commentFocusNode,
            replyingTo: _replyingTo,
            onCancelReply: () {
              setState(() { _replyingTo = null; });
            },
            onSubmit: _submitComment,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Comentários (${_commentsTree.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B))),
        InkWell(
          onTap: _toggleSort,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Text(
                  _sortDescending ? "Mais votados" : "Menos votados", 
                  style: const TextStyle(color: Color(0xFF009191), fontSize: 12, fontWeight: FontWeight.bold)
                ),
                Icon(_sortDescending ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 16, color: const Color(0xFF009191)),
              ],
            ),
          ),
        )
      ],
    );
  }
}