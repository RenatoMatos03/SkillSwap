import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  @override
  Widget build(BuildContext context) {
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
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text("Voltar", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(Icons.verified_user_outlined, size: 50, color: Color(0xFF009191)),
                  ),
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "Alterar Password",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1D204B)),
                  ),
                ),

                const SizedBox(height: 30),

                AuthCard(
                  child: Column(
                    children: [
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFB2DFDB), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.email_outlined, size: 20, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 13, color: Color(0xFF00796B)),
                                  children: [
                                    TextSpan(text: "Veja no seu email a password de "),
                                    TextSpan(text: "RESET", style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: " enviada e preenche-a aqui."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AuthTextField(
                        label: "Password",
                        hintText: "Cole aqui a password recebida",
                      ),
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "NOVA PASSWORD",
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, letterSpacing: 1.1, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),

                AuthCard(
                  child: Column(
                    children: [
                      AuthTextField(
                        label: "Nova Password",
                        hintText: "Mínimo 6 caracteres",
                        obscureText: _obscureNewPass,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNewPass ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureNewPass = !_obscureNewPass),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: "Confirmar Password",
                        hintText: "Repete a nova password",
                        obscureText: _obscureConfirmPass,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPass ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                AuthButton(
                  text: "Alterar Password",
                  onPressed: () {
                    
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}