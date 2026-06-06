class Question {
  final String title;
  final String description;
  final String status; // Aberta, Resolvida
  final String userName;
  final String userInitials;
  final int commentsCount;
  final String timeAgo;

  Question({
    required this.title,
    required this.description,
    required this.status,
    required this.userName,
    required this.userInitials,
    required this.commentsCount,
    required this.timeAgo,
  });
}