class CommentModel {
  String? id;
  String? parentCommentId; // NOVO: Para identificar a quem pertence o subcomentário
  final String userId;
  final String userName;
  final String userInitials;
  final String badge;
  final DateTime createdAt; 
  String text; // Deixou de ser final para podermos adicionar @ menções
  int votes; 
  bool isSolution; 
  final List<CommentModel> replies;

  CommentModel({
    this.id,
    this.parentCommentId,
    required this.userId,
    required this.userName,
    required this.userInitials,
    required this.badge,
    required this.createdAt,
    required this.text,
    required this.votes,
    this.isSolution = false,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'agora';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Guarda o ID gerado no array
      'parentCommentId': parentCommentId, // Guarda o pai
      'userId': userId,
      'userName': userName,
      'userInitials': userInitials,
      'badge': badge,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'text': text,
      'votes': votes,
      'isSolution': isSolution,
      'replies': replies.map((x) => x.toMap()).toList(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map, String docId) {
    return CommentModel(
      id: map['id'] ?? docId, // Aproveita o ID do map se existir (útil para os arrays)
      parentCommentId: map['parentCommentId'],
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userInitials: map['userInitials'] ?? '',
      badge: map['badge'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      text: map['text'] ?? '',
      votes: map['votes'] ?? 0,
      isSolution: map['isSolution'] ?? false,
      replies: map['replies'] != null 
          ? List<CommentModel>.from((map['replies'] as List).map((x) => CommentModel.fromMap(x, x['id'] ?? '')))
          : [],
    );
  }
}