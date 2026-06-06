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

class HomeUserProfile {
  final String fullName;
  final String courseLabel;
  final String initials;
  final String balance;
  final String greetingName;
  final String streakText;

  const HomeUserProfile({
    required this.fullName,
    required this.courseLabel,
    required this.initials,
    required this.balance,
    required this.greetingName,
    required this.streakText,
  });
}
