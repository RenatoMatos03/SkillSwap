import 'package:flutter/material.dart';

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

class LeaderboardItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const LeaderboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

