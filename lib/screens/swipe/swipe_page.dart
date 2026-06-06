import 'package:flutter/material.dart';
import '../../models/swipe/student_profile.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/student_card.dart';
import 'match_page.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  // Mock Data: A nossa base de dados provisória
  final List<StudentProfile> _profiles = [
    StudentProfile(
      name: "Ana Silva",
      course: "LEI - 2º Ano",
      imagePath: "assets/ana_silva.jpg",
      rating: 3.0,
      domina: "CM, POO",
      precisa: "Bases de Dados",
      phoneNumber: "351912345678",
    ),
    StudentProfile(
      name: "Miguel Costa",
      course: "MIEEC - 3º Ano",
      imagePath: "assets/miguel_costa.jpg",
      rating: 4.0,
      domina: "Física II, Circuitos",
      precisa: "Cálculo III",
      phoneNumber: "351912345679",
    ),
  ];

  int _currentIndex = 0;

  void _onPanEnd(DragEndDetails details) {
    const double velocityThreshold = 300.0;
    double dx = details.velocity.pixelsPerSecond.dx;
    double dy = details.velocity.pixelsPerSecond.dy;

    if (dy < -velocityThreshold && dy.abs() > dx.abs()) {
      // SWIPE PARA CIMA
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MatchPage(phoneNumber: _profiles[_currentIndex].phoneNumber),
        ),
      );
    } else if (dx > velocityThreshold) {
      // SWIPE PARA A DIREITA
      setState(() {
        if (_currentIndex < _profiles.length - 1) {
          _currentIndex++;
        }
      });
    } else if (dx < -velocityThreshold) {
      // SWIPE PARA A ESQUERDA
      setState(() {
        if (_currentIndex > 0) {
          _currentIndex--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: GestureDetector(
        onPanEnd: _onPanEnd,
        child: Stack(
          children: [
            // O Cartão do Aluno Limpo
            StudentCard(profile: _profiles[_currentIndex]),
          ],
        ),
      ),
    );
  }
}
