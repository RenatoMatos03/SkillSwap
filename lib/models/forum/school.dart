import 'package:flutter/material.dart';

class School {
  final String acronym;
  final String name;
  final int coursesCount;
  final IconData icon;

  School({
    required this.acronym,
    required this.name,
    required this.coursesCount,
    required this.icon,
  });
}