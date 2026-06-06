import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_page.dart';
import 'package:flutter/services.dart';

void main() async {
  // É obrigatório adicionar esta linha antes de usar o SystemChrome no main()
  WidgetsFlutterBinding.ensureInitialized(); 

  // Ocultar as barras de cima e de baixo (Modo Imersivo)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Garante que o Flutter está pronto antes de inicializar o Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase com as opções geradas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillSwap',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF009191),
      ),
      home: const LoginPage(),
    );
  }
}