class CommentModel {
  final String id;
  final String userName;
  final String userInitials;
  final String badge;
  final String time;
  final String text;
  int votes; // Removido o final para podermos dar upvote/downvote
  bool isSolution; // Removido o final
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.userName,
    required this.userInitials,
    required this.badge,
    required this.time,
    required this.text,
    required this.votes,
    this.isSolution = false,
    List<CommentModel>? replies,
  }) : replies = replies ?? [];
}