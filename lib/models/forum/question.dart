class Question {
  String? id; 
  final String userId; // <--- NOVO
  final String subjectName; 
  final String title;
  final String description;
  final String status; 
  final String userName;
  final String userInitials;
  final int commentsCount;
  final DateTime createdAt; 
  final List<String> tags;
  final String userCourse;

  Question({
    this.id,
    required this.userId,
    required this.subjectName,
    required this.title,
    required this.description,
    required this.status,
    required this.userName,
    required this.userInitials,
    required this.commentsCount,
    required this.createdAt,
    this.tags = const [],
    required this.userCourse,
  });

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
      'subjectName': subjectName,
      'title': title,
      'description': description,
      'status': status,
      'userName': userName,
      'userInitials': userInitials,
      'commentsCount': commentsCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'tags': tags,
      'userCourse': userCourse,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, String docId) {
    return Question(
      id: docId,
      userId: map['userId'] ?? '',
      subjectName: map['subjectName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Aberta',
      userName: map['userName'] ?? 'Anónimo',
      userInitials: map['userInitials'] ?? 'A',
      commentsCount: map['commentsCount'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      tags: List<String>.from(map['tags'] ?? []),
      userCourse: map['userCourse'] ?? '',
    );
  }
}