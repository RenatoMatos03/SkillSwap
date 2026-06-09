/// Modelo de comentário ou resposta do fórum com suporte a votos e soluções.
class CommentModel {
  String? id;
  String? parentCommentId;
  final String userId;
  final String userName;
  final String userInitials;
  final String badge;
  final DateTime createdAt;
  String text;
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

  /// Devolve o tempo decorrido desde a criação do comentário de forma legível.
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'agora';
  }

  /// Converte o comentário para um mapa compatível com o Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentCommentId': parentCommentId,
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

  /// Constrói um [CommentModel] a partir de um mapa Firestore.
  factory CommentModel.fromMap(Map<String, dynamic> map, String docId) {
    return CommentModel(
      id: map['id'] ?? docId,
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
