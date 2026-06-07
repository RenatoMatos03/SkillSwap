import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../widgets/widgets.dart';
import 'recover_password_page.dart';
import 'register_page.dart';
import 'verify_email_page.dart';
import 'personal_data_page.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  final _userService = UserService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;

      final emailVerified = await _authService.checkEmailVerified();
      if (!mounted) return;

      if (!emailVerified) {
        await _authService.sendEmailVerification();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(email: _emailController.text.trim()),
          ),
        );
        return;
      }

      final hasProfile = await _userService.profileExists();
      if (!mounted) return;

      if (!hasProfile) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PersonalDataPage()),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/skill_swap_logo.png',
                      height: 190,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A plataforma de aprendizagem entre pares',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              AuthCard(
                child: Column(
                  children: [
                    AuthTextField(
                      label: "Email institucional",
                      hintText: "2024146666@estudantes.ips.pt",
                      controller: _emailController,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: "Password",
                      hintText: "********",
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 30),
                    AuthButton(
                      text: _isLoading ? "A entrar..." : "Login",
                      onPressed: _isLoading ? null : _login,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RecoverPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Esqueceste-te da password?",
                          style: TextStyle(color: Color(0xFF009191)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Não tens conta? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: const Color(0xFF009191),
                    ),
                    child: const Text(
                      "Registar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}