import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_profile.dart';
import '../../widgets/student_card.dart';
import 'match_page.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  List<UserProfile> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final currentUserAuth = FirebaseAuth.instance.currentUser;
      if (currentUserAuth == null) {
        throw Exception("Nenhum utilizador com login feito.");
      }
      final myUid = currentUserAuth.uid;

      final myDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUid)
          .get();
      if (!myDoc.exists) {
        throw Exception("O meu perfil não foi encontrado na base de dados.");
      }

      final myProfile = UserProfile.fromMap(myDoc.id, myDoc.data()!);
      final myNeeds = myProfile.tagsProcura;

      final myNeedsNormalized = myNeeds
          .map((tag) => tag.trim().toLowerCase())
          .toList();

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final allUsers = snapshot.docs.map((doc) {
        return UserProfile.fromMap(doc.id, doc.data());
      }).toList();

      final matchedUsers = allUsers.where((otherUser) {
        if (otherUser.uid == myUid) return false;

        if (myNeedsNormalized.isEmpty) return false;

        bool hasMatch = otherUser.tagsOferta.any((tagDeles) {
          String tagNormalizada = tagDeles.trim().toLowerCase();

          return myNeedsNormalized.contains(tagNormalizada);
        });

        return hasMatch;
      }).toList();

      setState(() {
        _profiles = matchedUsers;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar do Firebase: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_profiles.isEmpty) return;

    const double velocityThreshold = 300.0;
    double dx = details.velocity.pixelsPerSecond.dx;
    double dy = details.velocity.pixelsPerSecond.dy;

    if (dy < -velocityThreshold && dy.abs() > dx.abs()) {
      // SWIPE PARA CIMA -> Abre a MatchPage e passa o número de telemóvel real
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MatchPage(phoneNumber: _profiles[_currentIndex].phoneNumber),
        ),
      );
    } else if (dx > velocityThreshold) {
      // SWIPE PARA A DIREITA -> Próximo cartão
      setState(() {
        if (_currentIndex < _profiles.length - 1) {
          _currentIndex++;
        }
      });
    } else if (dx < -velocityThreshold) {
      // SWIPE PARA A ESQUERDA -> Cartão anterior
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF009191)),
            )
          : _profiles.isEmpty
          ? const Center(
              child: Text(
                "Não há estudantes compatíveis no momento.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : GestureDetector(
              onPanEnd: _onPanEnd,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  // O Cartão final pronto a ser avaliado!
                  StudentCard(profile: _profiles[_currentIndex]),
                ],
              ),
            ),
    );
  }
}
