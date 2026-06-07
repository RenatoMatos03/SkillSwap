import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final DateTime birthDate;
  final String school;
  final String course;
  final String academicYear;
  final List<String> tagsProcura;
  final List<String> tagsOferta;
  final int coins;
  final int streak;
  final String phoneNumber;
  final String photoUrl;
  final double rating;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.birthDate,
    required this.school,
    required this.course,
    required this.academicYear,
    required this.tagsProcura,
    required this.tagsOferta,
    this.coins = 0,
    this.streak = 0,
    this.phoneNumber = '',
    this.photoUrl = '',
    this.rating = 0.0,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      school: map['school'] ?? '',
      course: map['course'] ?? '',
      academicYear: map['academicYear'] ?? '',
      tagsProcura: List<String>.from(map['tagsProcura'] ?? []),
      tagsOferta: List<String>.from(map['tagsOferta'] ?? []),
      coins: map['coins'] ?? 0,
      streak: map['streak'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'birthDate': Timestamp.fromDate(birthDate),
      'school': school,
      'course': course,
      'academicYear': academicYear,
      'tagsProcura': tagsProcura,
      'tagsOferta': tagsOferta,
      'coins': coins,
      'streak': streak,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'rating': rating,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
