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
    if (showCoinsInProfile != null)
      data['showCoinsInProfile'] = showCoinsInProfile;
    if (data.isEmpty) return;
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> deleteUserData(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // 🔥 A FUNÇÃO DE TRANSFERÊNCIA DE MOEDAS QUE A MENSAGENS PAGE PRECISA
  Future<void> transferCoins({
    required String senderUid,
    required String receiverUid,
    required int amount,
  }) async {
    final myRef = _db.collection('users').doc(senderUid);
    final theirRef = _db.collection('users').doc(receiverUid);

    await _db.runTransaction((transaction) async {
      final mySnapshot = await transaction.get(myRef);
      if (!mySnapshot.exists)
        throw Exception("O teu perfil não foi encontrado.");

      final myCurrentCoins = mySnapshot.data()?['coins'] ?? 0;

      if (myCurrentCoins < amount) {
        throw Exception(
          "Saldo insuficiente! Tens apenas $myCurrentCoins moedas.",
        );
      }

      transaction.update(myRef, {'coins': myCurrentCoins - amount});
      transaction.update(theirRef, {'coins': FieldValue.increment(amount)});
    });
  }
}
