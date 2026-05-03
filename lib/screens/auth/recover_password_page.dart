import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'change_password_page.dart';

class RecoverPasswordPage extends StatelessWidget {
  const RecoverPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {

    // 1. Cria o controller para capturar o texto
    final TextEditingController _emailController = TextEditingController();

    // 2. Função para validar email (Regex básica)
    bool _isEmailValid(String email) {
      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Voltar ao Login",
                            style: TextStyle(
                              color: Colors.grey, 
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF009191).withOpacity(0.1),
                          blurRadius: 40,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      size: 60,
                      color: Color(0xFF009191),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Título e Descrição
                const Center(
                  child: Text(
                    "Recuperar Password",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D204B),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        children: [
                          TextSpan(text: "Indique-nos o seu "),
                          TextSpan(
                            text: "EMAIL",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          TextSpan(text: " para enviar uma nova password."),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                AuthCard(
                  child: Column(
                    children: [
                      AuthTextField(
                        label: "Email",
                        hintText: "2024146666@estudantes.ips.pt",
                        controller: _emailController,
                      ),
                      const SizedBox(height: 30),
                      AuthButton(
                        text: "Enviar",
                        onPressed: () {
                          String email = _emailController.text.trim();

                          if (email.isEmpty) {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Por favor, introduza o seu email.")),
                            );
                          } else if (!_isEmailValid(email)) {
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Introduza um formato de email válido.")),
                            );
                          } else {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}