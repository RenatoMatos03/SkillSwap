import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> profileExists() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toMap());
  }

  Future<UserProfile?> getUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(uid, doc.data()!);
  }

  Future<void> updateProfile({
    required String uid,
    String? bio,
    String? photoUrl,
    String? phoneNumber,
    String? school,
    String? course,
    String? academicYear,
    List<String>? tagsOferta,
    List<String>? tagsProcura,
    bool? showCoinsInProfile,
    bool? defaultAnonymousMode
  }) async {
    final data = <String, dynamic>{};
    if (bio != null) data['bio'] = bio;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (school != null) data['school'] = school;
    if (course != null) data['course'] = course;
    if (academicYear != null) data['academicYear'] = academicYear;
    if (tagsOferta != null) data['tagsOferta'] = tagsOferta;
    if (tagsProcura != null) data['tagsProcura'] = tagsProcura;
    if (showCoinsInProfile != null) {
      data['showCoinsInProfile'] = showCoinsInProfile;
    }
    if (defaultAnonymousMode != null) data['defaultAnonymousMode'] = defaultAnonymousMode;
    if (data.isEmpty) return;
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUserData(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  Future<void> markQuizCompleted({
    required String uid,
    required int score,
  }) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekKey =
        '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
    await _db.collection('users').doc(uid).update({
      'lastQuizWeek': weekKey,
      'coins': FieldValue.increment(score),
      'quizzesDone': FieldValue.increment(1),
    });
  }

  static String currentWeekKey() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  Future<void> transferCoins({
    required String senderUid,
    required String receiverUid,
    required int amount,
    required double rating,
  }) async {
    final myRef = _db.collection('users').doc(senderUid);
    final theirRef = _db.collection('users').doc(receiverUid);

    String senderName = '';

    await _db.runTransaction((transaction) async {
      final mySnapshot = await transaction.get(myRef);
      final theirSnapshot = await transaction.get(theirRef);

      if (!mySnapshot.exists) throw Exception('O teu perfil não foi encontrado.');
      if (!theirSnapshot.exists) throw Exception('O perfil do destinatário não foi encontrado.');

      senderName = mySnapshot.data()?['name'] ?? 'Alguém';
      final myCurrentCoins = mySnapshot.data()?['coins'] ?? 0;

      if (myCurrentCoins < amount) {
        throw Exception('Saldo insuficiente! Tens apenas $myCurrentCoins moedas.');
      }

      final List<dynamic> currentRatings = theirSnapshot.data()?['ratings'] ?? [];
      final updatedRatings = currentRatings.map((e) => (e as num).toDouble()).toList()..add(rating);
      final newAverage = updatedRatings.fold(0.0, (p, e) => p + e) / updatedRatings.length;

      transaction.update(myRef, {'coins': myCurrentCoins - amount});
      transaction.update(theirRef, {
        'coins': FieldValue.increment(amount),
        'ratings': FieldValue.arrayUnion([rating]),
        'rating': newAverage,
      });
    });

    await _db
        .collection('users')
        .doc(receiverUid)
        .collection('notifications')
        .add({
      'type': 'coins_received',
      'senderName': senderName,
      'coins': amount,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> maybeNotifyQuizAvailable(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final lastQuizWeek = data['lastQuizWeek'] as String?;
    final currentWeek = currentWeekKey();

    // Only notify if the user has done a quiz before AND a new week started
    if (lastQuizWeek == null || lastQuizWeek == currentWeek) return;

    // Avoid duplicate notification for the same week
    final lastNotifiedWeek = data['lastQuizNotifiedWeek'] as String?;
    if (lastNotifiedWeek == currentWeek) return;

    await _db.collection('users').doc(uid).collection('notifications').add({
      'type': 'quiz_available',
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('users').doc(uid).update({
      'lastQuizNotifiedWeek': currentWeek,
    });
  }

  Future<void> markNotificationsRead(String uid) async {
    final unread = await _db
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .get();
    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }
}