import 'package:flutter/material.dart';

/// Modelo de escola do fórum.
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

  /// Converte a escola para um mapa compatível com o Firestore.
  Map<String, dynamic> toMap() {
    return {
      'acronym': acronym,
      'name': name,
      'coursesCount': coursesCount,
      'iconCode': icon.codePoint,
    };
  }

  /// Constrói uma [School] a partir de um mapa Firestore.
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
