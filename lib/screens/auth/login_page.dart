import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

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
              // Logo e Título
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/skill_swap_logo.png',
                      height: 190,
                      fit: BoxFit.contain,
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
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      label: "Password",
                      hintText: "********",
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    AuthButton(
                      text: "Login",
                      onPressed: () {
                        // Lógica de login
                      },
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Navegar para Recuperar Password
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
              
              // Link para Registo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não tens conta? "),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Registar",
                      style: TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold),
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