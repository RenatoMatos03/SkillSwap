import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Emite o utilizador atual sempre que o estado de auth muda (login/logout/app restart)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Não existe nenhuma conta com este email.';
      case 'wrong-password':
        return 'Password incorreta.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifica o email e a password.';
      case 'email-already-in-use':
        return 'Este email já está registado.';
      case 'weak-password':
        return 'A password é demasiado fraca (mínimo 6 caracteres).';
      case 'invalid-email':
        return 'Formato de email inválido.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tenta novamente mais tarde.';
      default:
        return 'Erro: ${e.message}';
    }
  }
}