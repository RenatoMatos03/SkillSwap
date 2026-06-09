import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/forum/comment_model.dart';
import '../../services/forum_service.dart';
import 'custom_badge.dart';
import '../../utils/utils.dart'; // <--- O TEU NOVO IMPORT LIMPO

class CommentItem extends StatefulWidget {
  final String questionId;
  final String rootCommentId; 
  final CommentModel comment;
  final Map<String, List<CommentModel>>? groupedReplies; 
  final Function(String, CommentModel) onReply;
  final bool showAcceptButton;
  final VoidCallback onSolutionToggled;
  final bool isSubComment;
  final int depth; 

  const CommentItem({
    super.key,
    required this.questionId,
    required this.rootCommentId,
    required this.comment,
    this.groupedReplies,
    required this.onReply,
    required this.showAcceptButton,
    required this.onSolutionToggled,
    this.isSubComment = false,
    this.depth = 0, 
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isExpanded = false;
  String _voteStatus = 'none';
  
  late int _localVotes;
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    _localVotes = widget.comment.votes;
  }

  @override
  void didUpdateWidget(CommentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isVoting) {
      _localVotes = widget.comment.votes;
    }
  }

  void _handleVote(bool isUp) async {
    int change = 0;
    
    setState(() {
      if (isUp) {
        if (_voteStatus == 'up') {
          _voteStatus = 'none'; 
          change = -1;
        } else if (_voteStatus == 'down') {
          _voteStatus = 'up'; 
          change = 2;
        } else {
          _voteStatus = 'up'; 
          change = 1;
        }
      } else {
        if (_voteStatus == 'down') {
          _voteStatus = 'none'; 
          change = 1;
        } else if (_voteStatus == 'up') {
          _voteStatus = 'down'; 
          change = -2;
        } else {
          _voteStatus = 'down'; 
          change = -1;
        }
      }
      
      _localVotes += change;
      _isVoting = true; 
    });

    if (change != 0) {
      if (widget.isSubComment) {
        if (widget.rootCommentId.isNotEmpty && widget.comment.id != null) {
          await ForumService().voteReply(widget.questionId, widget.rootCommentId, widget.comment.id!, change);
        }
      } else if (widget.comment.id != null) {
        await ForumService().voteComment(widget.questionId, widget.comment.id!, change);
      }
    }

    if (mounted) {
      setState(() {
        _isVoting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandColor = Color(0xFF009191);
    
    bool isUpvoted = _voteStatus == 'up';
    bool isDownvoted = _voteStatus == 'down';

    Color upIconColor = isUpvoted ? brandColor : Colors.grey[500]!;
    Color downIconColor = isDownvoted ? Colors.grey[800]! : Colors.grey[500]!; 
    Color voteTextColor = isUpvoted ? brandColor : (isDownvoted ? Colors.grey[800]! : const Color(0xFF1D204B));
    Color voteBorderColor = isUpvoted ? brandColor : (isDownvoted ? Colors.grey[800]! : Colors.grey[300]!);
    Color voteBgColor = isUpvoted ? brandColor.withOpacity(0.1) : (isDownvoted ? Colors.grey[200]! : Colors.transparent);

    // CHAMA A FUNÇÃO GLOBAL AQUI
    String acronym = getCourseAcronym(widget.comment.badge);

    Map<String, List<CommentModel>> map = widget.groupedReplies ?? {};

    if (!widget.isSubComment && widget.groupedReplies == null) {
      map = {};
      for (var r in widget.comment.replies) {
        String pId = r.parentCommentId ?? widget.comment.id!;
        map.putIfAbsent(pId, () => []).add(r);
      }
      for (var list in map.values) {
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }
    }

    List<CommentModel> myChildren = map[widget.comment.id] ?? [];

    double screenWidth = MediaQuery.of(context).size.width;
    double margins = 76.0; 
    double currentIndent = widget.depth * 14.0; 
    double idealWidth = screenWidth - margins - currentIndent; 
    
    double contentWidth = max(idealWidth, 270.0); 

    Widget content = SizedBox(
      width: contentWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14, 
                backgroundColor: brandColor, 
                child: Text(widget.comment.userInitials, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(widget.comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D204B))),
                    if (acronym.isNotEmpty)
                      CustomBadge(text: acronym, textColor: brandColor, bgColor: const Color(0xFFE0F2F1)),
                    Text("há ${widget.comment.timeAgo}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Text(widget.comment.text, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 13, color: Color(0xFF4F4F4F), height: 1.5)),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: voteBgColor,
                  border: Border.all(color: voteBorderColor), 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(children: [
                  GestureDetector(onTap: () => _handleVote(true), child: Icon(Icons.keyboard_arrow_up, size: 16, color: upIconColor)),
                  const SizedBox(width: 4),
                  Text("$_localVotes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: voteTextColor)),
                  const SizedBox(width: 4),
                  GestureDetector(onTap: () => _handleVote(false), child: Icon(Icons.keyboard_arrow_down, size: 16, color: downIconColor)),
                ]),
              ),
              const SizedBox(width: 16),
              
              GestureDetector(
                onTap: () => widget.onReply(widget.rootCommentId, widget.comment), 
                child: const Row(children: [Icon(Icons.reply, size: 16, color: Colors.grey), SizedBox(width: 4), Text("Responder", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))]),
              ),
              
              if (myChildren.isNotEmpty) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(children: [
                    Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: brandColor), 
                    const SizedBox(width: 4), 
                    Text(_isExpanded ? "Ocultar" : "Ver ${myChildren.length} res.", style: const TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 12))
                  ]),
                ),
              ],

              const Spacer(),
              
              if (widget.comment.isSolution)
                const Row(children: [Icon(Icons.check, size: 16, color: Color(0xFF00E676)), SizedBox(width: 4), Text("Solução", style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12))])
              else if (widget.showAcceptButton && !widget.isSubComment)
                TextButton(
                  onPressed: widget.onSolutionToggled, 
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text("✔ Aceitar", style: TextStyle(color: brandColor, fontWeight: FontWeight.bold, fontSize: 12)),
                )
            ],
          ),
        ],
      ),
    );

    if (widget.isSubComment) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.only(left: 12), 
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey[300]!, width: 2)) 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            if (_isExpanded && myChildren.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: myChildren.map((c) => CommentItem(
                  key: ValueKey(c.id), 
                  questionId: widget.questionId,
                  rootCommentId: widget.rootCommentId,
                  groupedReplies: map, 
                  comment: c,
                  onReply: widget.onReply,
                  showAcceptButton: false,
                  onSolutionToggled: () {},
                  isSubComment: true,
                  depth: widget.depth + 1, 
                )).toList(),
              ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.comment.isSolution ? const Color(0xFFF2FCF3) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.comment.isSolution ? const Color(0xFF00E676) : Colors.grey.withOpacity(0.2),
                width: widget.comment.isSolution ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
                if (_isExpanded && myChildren.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: myChildren.map((c) => CommentItem(
                        key: ValueKey(c.id), 
                        questionId: widget.questionId,
                        rootCommentId: widget.rootCommentId,
                        groupedReplies: map, 
                        comment: c,
                        onReply: widget.onReply,
                        showAcceptButton: false,
                        onSolutionToggled: () {},
                        isSubComment: true,
                        depth: widget.depth + 1, 
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}