class CommentModel {
  String? id;
  final String userId;
  final String userName;
  final String userInitials;
  final String badge;
  final DateTime createdAt; 
  final String text;
  int votes; 
  bool isSolution; 
  final List<CommentModel> replies;

  CommentModel({
    this.id,
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
      id: docId,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userInitials: map['userInitials'] ?? '',
      badge: map['badge'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      text: map['text'] ?? '',
      votes: map['votes'] ?? 0,
      isSolution: map['isSolution'] ?? false,
      replies: map['replies'] != null 
          ? List<CommentModel>.from((map['replies'] as List).map((x) => CommentModel.fromMap(x, '')))
          : [],
    );
  }
}