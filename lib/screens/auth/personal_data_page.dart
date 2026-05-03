import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'app_data_page.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  // Valores selecionados para os dropdowns
  String? selectedEscola;
  String? selectedCurso;
  String? selectedAno;

  // Listas de dados
  final List<String> escolas = ["Tecnologia de Setúbal", "Educação", "Ciências Empresariais"];
  final List<String> cursos = ["Licenciatura em Engenharia Informática", "Design de Comunicação", "Gestão"];
  final List<String> anos = ["1º Ano", "2º Ano", "3º Ano", "4º Ano", "5º Ano"];

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
                const SizedBox(height: 40),
                
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF009191),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                const Text(
                  "PASSO 1 DE 2",
                  style: TextStyle(
                    color: Color(0xFF009191),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Dados Pessoais",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D204B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Preenche as informações do teu perfil académico.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                
                const SizedBox(height: 30),
                
                AuthCard(
                  child: Column(
                    children: [
                      const AuthTextField(
                        label: "Nome",
                        hintText: "Renato Matos",
                      ),
                      const SizedBox(height: 20),
                      const AuthTextField(
                        label: "Data de Nascimento",
                        hintText: "08/04/2003",
                      ),
                      const SizedBox(height: 20),
                      
                      AuthDropdown(
                        label: "Escola",
                        hintText: "Selecionar Escola",
                        items: escolas,
                        value: selectedEscola,
                        onChanged: (val) => setState(() => selectedEscola = val),
                      ),
                      const SizedBox(height: 20),
                      
                      AuthDropdown(
                        label: "Curso",
                        hintText: "Selecionar Curso",
                        items: cursos,
                        value: selectedCurso,
                        onChanged: (val) => setState(() => selectedCurso = val),
                      ),
                      const SizedBox(height: 20),
                      
                      // Dropdown Ano Escolar usando o widget abstrato
                      AuthDropdown(
                        label: "Ano Escolar",
                        hintText: "Selecionar Ano",
                        items: anos,
                        value: selectedAno,
                        onChanged: (val) => setState(() => selectedAno = val),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Botão Avançar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AppDataPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009191),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Avançar ",
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}