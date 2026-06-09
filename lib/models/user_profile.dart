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
  final bool defaultAnonymousMode;
  final int coins;
  final int streak;
  final int helpsGiven;
  final int quizzesDone;
  final String bio;
  final String phoneNumber;
  final String photoUrl;
  final double rating;
  final List<double> ratings;
  final bool showCoinsInProfile;
  final List<String> matches;

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
    this.defaultAnonymousMode = false,
    this.coins = 0,
    this.streak = 0,
    this.helpsGiven = 0,
    this.quizzesDone = 0,
    this.bio = '',
    this.phoneNumber = '',
    this.photoUrl = '',
    this.rating = 0.0,
    this.ratings = const [],
    this.showCoinsInProfile = true,
    this.matches = const [],
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
      defaultAnonymousMode: map['defaultAnonymousMode'] ?? false,
      coins: map['coins'] ?? 0,
      streak: map['streak'] ?? 0,
      helpsGiven: map['helpsGiven'] ?? 0,
      quizzesDone: map['quizzesDone'] ?? 0,
      bio: map['bio'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      ratings: List<double>.from(
        (map['ratings'] ?? []).map((x) => (x as num).toDouble()),
      ),
      showCoinsInProfile: map['showCoinsInProfile'] ?? true,
      matches: List<String>.from(map['matches'] ?? []),
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
      'defaultAnonymousMode': defaultAnonymousMode,
      'coins': coins,
      'streak': streak,
      'helpsGiven': helpsGiven,
      'quizzesDone': quizzesDone,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'rating': rating,
      'ratings': ratings,
      'showCoinsInProfile': showCoinsInProfile,
      'matches': matches,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
