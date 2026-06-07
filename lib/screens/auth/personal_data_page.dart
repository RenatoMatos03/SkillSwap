import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import 'app_data_page.dart';

class PersonalDataPage extends StatefulWidget {
  const PersonalDataPage({super.key});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  final _nameController = TextEditingController();
  final _escolaController = TextEditingController();
  final _cursoController = TextEditingController();
  final _anoController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _escolaController.dispose();
    _cursoController.dispose();
    _anoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2003),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF009191)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String get _formattedDate {
    if (_selectedDate == null) return '';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
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
                      AuthTextField(
                        label: "Nome",
                        hintText: "Renato Matos",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 20),
                      // Date picker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Data de Nascimento",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F5F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                                  const SizedBox(width: 10),
                                  Text(
                                    _selectedDate == null ? "Selecionar data" : _formattedDate,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _selectedDate == null ? Colors.grey : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: "Escola",
                        hintText: "Ex: Tecnologia de Setúbal",
                        controller: _escolaController,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: "Curso",
                        hintText: "Ex: Engenharia Informática",
                        controller: _cursoController,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: "Ano Escolar",
                        hintText: "Ex: 2º Ano",
                        controller: _anoController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty ||
                          _selectedDate == null ||
                          _escolaController.text.trim().isEmpty ||
                          _cursoController.text.trim().isEmpty ||
                          _anoController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Preenche todos os campos.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppDataPage(
                            name: _nameController.text.trim(),
                            birthDate: _selectedDate!,
                            school: _escolaController.text.trim(),
                            course: _cursoController.text.trim(),
                            academicYear: _anoController.text.trim(),
                          ),
                        ),
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
