import 'package:flutter/material.dart';

class School {
  String? id;
  final String acronym;
  final String name;
  final int coursesCount;
  final IconData icon;

  School({
    this.id,
    required this.acronym,
    required this.name,
    required this.coursesCount,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'acronym': acronym,
      'name': name,
      'coursesCount': coursesCount,
      'iconCode': icon.codePoint,
    };
  }

  factory School.fromMap(Map<String, dynamic> map, String docId) {
    return School(
      id: docId,
      acronym: map['acronym'] ?? '',
      name: map['name'] ?? '',
      coursesCount: map['coursesCount'] ?? 0,
      icon: IconData(map['iconCode'] ?? Icons.school.codePoint, fontFamily: 'MaterialIcons'),
    );
  }
}