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
      if (_currentIndex < _profiles.length) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MatchPage(phoneNumber: _profiles[_currentIndex].phoneNumber),
          ),
        );
      }
    } else if (dx > velocityThreshold) {
      setState(() {
        if (_currentIndex < _profiles.length) {
          _currentIndex++;
        }
      });
    } else if (dx < -velocityThreshold) {
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
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF009191)),
            )
          : _profiles.isEmpty
          ? const Center(
              child: Text(
                "Não há estudantes compatíveis no momento.",
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            )
          : GestureDetector(
              onPanEnd: _onPanEnd,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  _currentIndex >= _profiles.length
                      ? _buildEndOfListMessage()
                      : StudentCard(profile: _profiles[_currentIndex]),
                ],
              ),
            ),
    );
  }

  Widget _buildEndOfListMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 80, color: Color(0xFF009191)),
          SizedBox(height: 16),
          Text(
            "Chegaste ao fim!",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Viste todos os estudantes compatíveis.",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
