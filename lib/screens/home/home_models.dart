import 'package:flutter/material.dart';

/// Modelo de notícia ou dica para o carrossel da página inicial.
class NewsItem {
  final String tag;
  final String title;
  final String subtitle;
  final String date;

  const NewsItem({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.date,
  });
}

/// Modelo de item do leaderboard com campo Firestore e sufixo de valor.
class LeaderboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String field;
  final String valueSuffix;

  const LeaderboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.field,
    required this.valueSuffix,
  });
}
