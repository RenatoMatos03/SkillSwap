import 'package:flutter/material.dart';

class Course {
  final String acronym;
  final String name;
  final String type; // ex: Licenciatura
  final int subjectsCount;
  final String area;
  final Color color;

  Course({
    required this.acronym,
    required this.name,
    required this.type,
    required this.subjectsCount,
    required this.area,
    required this.color,
  });
}