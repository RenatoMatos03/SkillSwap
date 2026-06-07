import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/widgets.dart';
import 'personal_data_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _authService = AuthService();

  bool _isChecking = false;
  bool _isResending = false;
  String? _errorMessage;

  Future<void> _checkVerified() async {
    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      final verified = await _authService.checkEmailVerified();
      if (!mounted) return;

      if (verified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PersonalDataPage()),
        );
      } else {
        setState(() => _errorMessage = 'Email ainda não verificado. Clica no link que enviámos.');
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);
    try {
      await _authService.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email reenviado! Verifica a tua caixa de correio.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 60,
                      color: Color(0xFF009191),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Confirma o teu Email",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D204B),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Enviámos um link de verificação para:",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.email,
                    style: const TextStyle(
                      color: Color(0xFF008B8B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Abre o email e clica no link. Depois volta aqui e prime "Já verifiquei".',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 40),
                AuthButton(
                  text: _isChecking ? "A verificar..." : "Já verifiquei",
                  onPressed: _isChecking ? null : _checkVerified,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Não recebeste o email? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: _isResending ? null : _resendEmail,
                      child: Text(
                        _isResending ? "A reenviar..." : "Reenviar",
                        style: const TextStyle(
                          color: Color(0xFF009191),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 16, color: Colors.grey),
                  label: const Text("Voltar", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
