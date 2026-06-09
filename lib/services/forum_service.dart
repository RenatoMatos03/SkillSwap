import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum/question.dart';
import '../models/forum/comment_model.dart';
import '../models/forum/school.dart';
import '../models/forum/course.dart';

class ForumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<School>> getSchoolsStream() {
    return _db.collection('schools')
        .orderBy('acronym')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => School.fromMap(doc.data(), doc.id)).toList());
  }

  Stream<List<Course>> getCoursesStream(String schoolAcronym) {
    return _db.collection('courses')
        .where('schoolAcronym', isEqualTo: schoolAcronym)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Course.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> createQuestion(Question question) async {
    final docRef = _db.collection('questions').doc();
    question.id = docRef.id;
    await docRef.set(question.toMap());

    final courseQuery = await _db.collection('courses').where('acronym', isEqualTo: question.subjectName).limit(1).get();
    if (courseQuery.docs.isNotEmpty) {
      await courseQuery.docs.first.reference.update({
        'questionsCount': FieldValue.increment(1)
      });
    }
  }

  Stream<List<Question>> getQuestionsStream(String subjectName) {
    return _db.collection('questions')
        .where('subjectName', isEqualTo: subjectName)
        .snapshots()
        .map((snapshot) {
          final questions = snapshot.docs.map((doc) => Question.fromMap(doc.data(), doc.id)).toList();
          questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return questions;
        });
  }

  Future<void> addComment(String questionId, CommentModel comment) async {
    final docRef = _db.collection('questions').doc(questionId).collection('comments').doc();
    comment.id = docRef.id;
    await docRef.set(comment.toMap());
    
    await _db.collection('questions').doc(questionId).update({
      'commentsCount': FieldValue.increment(1)
    });
  }

  Future<void> addReply(String questionId, String commentId, CommentModel reply) async {
    await _db.collection('questions').doc(questionId)
        .collection('comments').doc(commentId)
        .update({
          'replies': FieldValue.arrayUnion([reply.toMap()])
        });
  }

  Stream<List<CommentModel>> getCommentsStream(String questionId) {
    return _db.collection('questions')
        .doc(questionId)
        .collection('comments')
        .snapshots()
        .map((snapshot) {
          final comments = snapshot.docs.map((doc) => CommentModel.fromMap(doc.data(), doc.id)).toList();
          comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return comments;
        });
  }

  Future<void> markAsSolution(String questionId, String commentId, String commentAuthorId) async {
    final batch = _db.batch();

    final questionRef = _db.collection('questions').doc(questionId);
    batch.update(questionRef, {'status': 'Resolvida'});

    final commentRef = questionRef.collection('comments').doc(commentId);
    batch.update(commentRef, {'isSolution': true});

    if (commentAuthorId.isNotEmpty) {
      final userRef = _db.collection('users').doc(commentAuthorId);
      batch.update(userRef, {'coins': FieldValue.increment(2)});
    }

    await batch.commit(); 
  }

  // --- NOVA FUNÇÃO: APAGAR A PERGUNTA ---
  Future<void> deleteQuestion(String questionId, String subjectName) async {
    final batch = _db.batch();

    // 1. Subtrai 1 ao contador de perguntas do curso
    final courseQuery = await _db.collection('courses').where('acronym', isEqualTo: subjectName).limit(1).get();
    if (courseQuery.docs.isNotEmpty) {
      batch.update(courseQuery.docs.first.reference, {
        'questionsCount': FieldValue.increment(-1)
      });
    }

    // 2. Apaga todos os comentários dentro desta pergunta para não deixar dados órfãos na BD
    final commentsSnapshot = await _db.collection('questions').doc(questionId).collection('comments').get();
    for (var doc in commentsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // 3. Apaga a própria pergunta
    final questionRef = _db.collection('questions').doc(questionId);
    batch.delete(questionRef);

    // Executa as ações todas juntas
    await batch.commit();
  }
}