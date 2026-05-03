import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/widgets.dart';
import 'personal_data_page.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email; // Recebe o email da tela anterior

  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  
  final List<TextEditingController> _controllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (_) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
                // Ícone da Carta
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.email_outlined, size: 60, color: Color(0xFF009191)),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Confirmar Email",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1D204B)),
                ),
                const SizedBox(height: 16),
                const Text("Foi enviado um código via e-mail:", style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 10),
                
                // Email dinâmico vindo da tela anterior
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.email,
                    style: const TextStyle(color: Color(0xFF008B8B), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),

                // Campos para inserir o código (5 dígitos)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) => _otpInput(index)),
                ),

                const SizedBox(height: 40),
                
                // Reenviar Código
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não recebeste o código? ", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Reenviar", style: TextStyle(color: Color(0xFF009191), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                AuthButton(
                  text: "Confirmar",
                  onPressed: () {
                    String code = _controllers.map((e) => e.text).join();
                    print("Código inserido: $code");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PersonalDataPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
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

  Widget _otpInput(int index) {
    return Container(
      height: 80,
      width: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          decoration: const InputDecoration(
            counterText: "", 
            border: InputBorder.none,
            
            contentPadding: EdgeInsets.zero, 
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            if (value.isNotEmpty && index < 4) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
        ),
      ),
    );
  }
}