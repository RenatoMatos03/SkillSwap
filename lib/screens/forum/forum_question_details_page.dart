import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/forum/comment_model.dart';
import '../../models/forum/question.dart';
import '../../services/forum_service.dart';
import '../../services/user_service.dart';
import '../../widgets/forum/widgets_forum.dart';
import '../../widgets/widgets.dart';
import '../../utils/utils.dart'; // <--- O TEU NOVO IMPORT LIMPO

class ForumQuestionDetailsPage extends StatefulWidget {
  final Question question;

  const ForumQuestionDetailsPage({super.key, required this.question});

  @override
  State<ForumQuestionDetailsPage> createState() => _ForumQuestionDetailsPageState();
}

class _ForumQuestionDetailsPageState extends State<ForumQuestionDetailsPage> {
  final FocusNode _commentFocusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();
  
  bool _sortDescending = true;  
  CommentModel? _replyingTo;    
  String? _replyingToRootId; 
  late bool _isResolved;

  @override
  void initState() {
    super.initState();
    _isResolved = widget.question.status == 'Resolvida';
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    String text = _commentController.text.trim();
    if (text.isEmpty) return;

    final profile = await UserService().getUserProfile();
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final String generatedId = "${DateTime.now().millisecondsSinceEpoch}_$uid";

    final newComment = CommentModel(
      id: generatedId,
      parentCommentId: _replyingTo?.id, 
      userId: uid,
      userName: profile?.name ?? "Utilizador",
      // CHAMA A FUNÇÃO GLOBAL AQUI
      userInitials: profile != null ? getInitials(profile.name) : "U",
      badge: profile?.course ?? "IPS",
      createdAt: DateTime.now(),
      votes: 0,
      text: text,
      isSolution: false,
    );

    if (_replyingTo != null && _replyingToRootId != null) {
      await ForumService().addReply(widget.question.id!, _replyingToRootId!, newComment);
    } else {
      await ForumService().addComment(widget.question.id!, newComment);
    }

    _commentController.clear();
    setState(() {
      _replyingTo = null;
      _replyingToRootId = null;
    });
    _commentFocusNode.unfocus();
  }

  void _confirmAndMarkSolution(CommentModel comment) {
    showDialog(
      context: context,
      builder: (ctx) => CustomConfirmationDialog(
        title: "Aceitar Solução?",
        content: "Tens a certeza que queres marcar esta resposta como a solução?\n\nEsta ação não pode ser revertida e o autor receberá 2 moedas.",
        onConfirm: () async {
          await ForumService().markAsSolution(widget.question.id!, comment.id!, comment.userId);
          setState(() => _isResolved = true); 
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Solução aceite!"), backgroundColor: Colors.green)
            );
          }
        },
      )
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => CustomConfirmationDialog(
        title: "Eliminar Questão?",
        content: "Irá apagar a sua questão.\n\nNão conseguirá reverter esta ação e não receberá as moedas de volta. Tem a certeza?",
        confirmText: "Eliminar", 
        onConfirm: () async {
          await ForumService().deleteQuestion(widget.question.id!, widget.question.subjectName);
          
          if (mounted) {
            Navigator.pop(context); 
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("A questão foi eliminada com sucesso."), backgroundColor: Colors.teal)
            );
          }
        },
      )
    );
  }

  Widget _buildAuthorHeader(bool isOwner) {
    // CHAMA A FUNÇÃO GLOBAL AQUI
    final String acronym = getCourseAcronym(widget.question.userCourse);

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF1D204B)))),
          const SizedBox(width: 16),
          CircleAvatar(radius: 20, backgroundColor: const Color(0xFF009191), child: Text(widget.question.userInitials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(widget.question.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), 
                    if (acronym.isNotEmpty)
                      CustomBadge(text: acronym, textColor: const Color(0xFF009191), bgColor: const Color(0xFF009191).withOpacity(0.1))
                  ]
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomBadge(text: _isResolved ? "Resolvida" : "Aberta", textColor: _isResolved ? const Color(0xFF009191) : Colors.grey[700]!, bgColor: _isResolved ? const Color(0xFFE0F2F1) : Colors.grey[200]!, icon: _isResolved ? Icons.check_circle : Icons.circle_outlined), 
                    Text("há ${widget.question.timeAgo}", style: const TextStyle(color: Colors.grey, fontSize: 12))
                  ]
                )
              ],
            ),
          ),
          
          if (isOwner)
            Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                offset: const Offset(0, 40),
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation();
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text("Eliminar Questão", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final bool isOwner = currentUserId != null && currentUserId == widget.question.userId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: ForumService().getCommentsStream(widget.question.id!),
              builder: (context, snapshot) {
                List<CommentModel> commentsTree = snapshot.data ?? [];
                
                commentsTree.sort((a, b) {
                  if (a.isSolution && !b.isSolution) return -1;
                  if (!a.isSolution && b.isSolution) return 1;
                  return _sortDescending ? b.votes.compareTo(a.votes) : a.votes.compareTo(b.votes);
                });

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildAuthorHeader(isOwner), 
                    QuestionFullBody(question: widget.question),
                    const SizedBox(height: 32),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Comentários (${commentsTree.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D204B))),
                        InkWell(
                          onTap: () => setState(() => _sortDescending = !_sortDescending),
                          child: Padding(padding: const EdgeInsets.all(4.0), child: Row(children: [Text(_sortDescending ? "Mais votados" : "Menos votados", style: const TextStyle(color: Color(0xFF009191), fontSize: 12, fontWeight: FontWeight.bold)), Icon(_sortDescending ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, size: 16, color: const Color(0xFF009191))])),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    ...commentsTree.map((comment) {
                      final bool canAccept = isOwner && !_isResolved && comment.userId != currentUserId;

                      return CommentItem(
                        key: ValueKey(comment.id), 
                        questionId: widget.question.id!,
                        rootCommentId: comment.id!, 
                        comment: comment,
                        onReply: (rootId, c) { 
                          setState(() {
                            _replyingToRootId = rootId;
                            _replyingTo = c;
                          });
                          _commentFocusNode.requestFocus();
                        },
                        showAcceptButton: canAccept, 
                        onSolutionToggled: () => _confirmAndMarkSolution(comment),
                      );
                    }),
                  ],
                );
              }
            ),
          ),
          CommentInput(
            controller: _commentController,
            focusNode: _commentFocusNode,
            replyingTo: _replyingTo,
            onCancelReply: () => setState(() {
              _replyingTo = null;
              _replyingToRootId = null;
            }),
            onSubmit: _submitComment,
          ),
        ],
      ),
    );
  }
}