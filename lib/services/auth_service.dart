import 'package:firebase_auth/firebase_auth.dart';

/// Serviço de autenticação Firebase com registo, login e recuperação de password.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Emite o utilizador atual sempre que o estado de autenticação muda.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Regista um novo utilizador com email e password.
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

  /// Autentica um utilizador existente com email e password.
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

  /// Envia um email de verificação para o utilizador atual.
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Recarrega o utilizador e devolve se o email está verificado.
  Future<bool> checkEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  /// Envia um email de recuperação de password para o endereço indicado.
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

  /// Traduz erros do Firebase Authentication para mensagens legíveis em português.
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
