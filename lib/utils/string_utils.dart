// A tua função original
String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  return parts.isNotEmpty && parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
}

// A nova função para as siglas dos cursos
String getCourseAcronym(String courseName) {
  if (courseName.isEmpty) return "";
  final ignoreWords = ['em', 'de', 'e', 'do', 'da', 'dos', 'das', 'para', 'com'];
  return courseName
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty && !ignoreWords.contains(w.toLowerCase()))
      .map((w) => w[0].toUpperCase())
      .join('');
}