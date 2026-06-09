import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum/question.dart';
import '../models/forum/comment_model.dart';
import '../models/forum/school.dart';
import '../models/forum/course.dart';

/// Serviço de acesso ao fórum no Firestore: escolas, cursos, perguntas e comentários.
class ForumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Devolve um stream com a lista de escolas ordenada por sigla.
  Stream<List<School>> getSchoolsStream() {
    return _db.collection('schools')
        .orderBy('acronym')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => School.fromMap(doc.data(), doc.id)).toList());
  }

  /// Devolve um stream com os cursos de uma escola identificada pela sua sigla.
  Stream<List<Course>> getCoursesStream(String schoolAcronym) {
    return _db.collection('courses')
        .where('schoolAcronym', isEqualTo: schoolAcronym)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Course.fromMap(doc.data(), doc.id)).toList());
  }

  /// Cria uma nova pergunta e incrementa o contador de perguntas do curso.
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

  /// Devolve um stream com as perguntas de uma disciplina ordenadas por data.
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

  /// Adiciona um comentário raiz a uma pergunta e incrementa o contador.
  Future<void> addComment(String questionId, CommentModel comment) async {
    final docRef = _db.collection('questions').doc(questionId).collection('comments').doc();
    comment.id = docRef.id;
    await docRef.set(comment.toMap());

    await _db.collection('questions').doc(questionId).update({
      'commentsCount': FieldValue.increment(1)
    });
  }

  /// Adiciona uma resposta aninhada a um comentário existente via arrayUnion.
  Future<void> addReply(String questionId, String commentId, CommentModel reply) async {
    await _db.collection('questions').doc(questionId)
        .collection('comments').doc(commentId)
        .update({
          'replies': FieldValue.arrayUnion([reply.toMap()])
        });
  }

  /// Devolve um stream com os comentários de uma pergunta ordenados por data.
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

  /// Marca um comentário como solução, resolve a pergunta e recompensa o autor.
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

  /// Atualiza os votos de um comentário raiz.
  Future<void> voteComment(String questionId, String commentId, int voteChange) async {
    final commentRef = _db.collection('questions').doc(questionId).collection('comments').doc(commentId);
    await commentRef.update({
      'votes': FieldValue.increment(voteChange)
    });
  }

  /// Atualiza os votos de uma resposta dentro de um array via transação.
  Future<void> voteReply(String questionId, String parentCommentId, String replyId, int voteChange) async {
    final commentRef = _db.collection('questions').doc(questionId).collection('comments').doc(parentCommentId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(commentRef);
      if (!snapshot.exists) return;

      final data = snapshot.data();
      if (data == null || data['replies'] == null) return;

      List<dynamic> replies = data['replies'];
      List<Map<String, dynamic>> updatedReplies = [];

      for (var r in replies) {
        Map<String, dynamic> replyMap = Map<String, dynamic>.from(r as Map);
        if (replyMap['id'] == replyId) {
          replyMap['votes'] = (replyMap['votes'] ?? 0) + voteChange;
        }
        updatedReplies.add(replyMap);
      }

      transaction.update(commentRef, {'replies': updatedReplies});
    });
  }

  /// Elimina uma pergunta, os seus comentários e decrementa o contador do curso.
  Future<void> deleteQuestion(String questionId, String subjectName) async {
    final batch = _db.batch();

    final courseQuery = await _db.collection('courses').where('acronym', isEqualTo: subjectName).limit(1).get();
    if (courseQuery.docs.isNotEmpty) {
      batch.update(courseQuery.docs.first.reference, {
        'questionsCount': FieldValue.increment(-1)
      });
    }

    final commentsSnapshot = await _db.collection('questions').doc(questionId).collection('comments').get();
    for (var doc in commentsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    final questionRef = _db.collection('questions').doc(questionId);
    batch.delete(questionRef);

    await batch.commit();
  }
}
