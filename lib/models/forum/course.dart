import 'package:flutter/material.dart';

class Course {
  String? id;
  final String schoolAcronym; 
  final String acronym;
  final String name;
  final String type; 
  final int questionsCount;
  final String area;
  final Color color;

  Course({
    this.id,
    required this.schoolAcronym,
    required this.acronym,
    required this.name,
    required this.type,
    required this.questionsCount,
    required this.area,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'schoolAcronym': schoolAcronym,
      'acronym': acronym,
      'name': name,
      'type': type,
      'questionsCount': questionsCount,
      'area': area,
      'colorValue': color.value, 
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, String docId) {
    return Course(
      id: docId,
      schoolAcronym: map['schoolAcronym'] ?? '',
      acronym: map['acronym'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      questionsCount: map['questionsCount'] ?? 0, // <--- ATUALIZADO
      area: map['area'] ?? '',
      color: Color(map['colorValue'] ?? 0xFF00BFA5),
    );
  }
}