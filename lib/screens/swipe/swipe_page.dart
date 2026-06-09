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
      if (currentUserAuth == null) return;

      final myUid = currentUserAuth.uid;

      // Busca o meu perfil para saber o que preciso
      final myDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUid)
          .get();
      if (!myDoc.exists) return;

      final myProfile = UserProfile.fromMap(myDoc.id, myDoc.data()!);
      final myNeedsNormalized = myProfile.tagsProcura
          .map((t) => t.trim().toLowerCase())
          .toList();

      // Busca todos os utilizadores
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      final allUsers = snapshot.docs
          .map((doc) => UserProfile.fromMap(doc.id, doc.data()))
          .toList();

      // Filtra apenas quem oferece o que eu preciso e não sou eu
      final matchedUsers = allUsers.where((otherUser) {
        if (otherUser.uid == myUid) return false;
        if (myNeedsNormalized.isEmpty) return false;

        return otherUser.tagsOferta.any(
          (tag) => myNeedsNormalized.contains(tag.trim().toLowerCase()),
        );
      }).toList();

      if (mounted) {
        setState(() {
          _profiles = matchedUsers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (_profiles.isEmpty || _currentIndex >= _profiles.length) return;

    const double velocityThreshold = 300.0;
    double dx = details.velocity.pixelsPerSecond.dx;
    double dy = details.velocity.pixelsPerSecond.dy;

    // Swipe para cima -> MATCH!
    if (dy < -velocityThreshold && dy.abs() > dx.abs()) {
      final matchedUser = _profiles[_currentIndex];
      final myUid = FirebaseAuth.instance.currentUser!.uid;

      // 🔥 GRAVA O MATCH NO FIREBASE
      FirebaseFirestore.instance.collection('users').doc(myUid).update({
        'matches': FieldValue.arrayUnion([matchedUser.uid]),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchPage(profileName: matchedUser.name),
        ),
      ).then((_) {
        setState(() {
          _currentIndex++;
        });
      });
    }
    // Swipe para direita/esquerda -> SKIP
    else if (dx.abs() > velocityThreshold) {
      setState(() {
        _currentIndex++;
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
          : _profiles.isEmpty || _currentIndex >= _profiles.length
          ? _buildEndOfListMessage()
          : GestureDetector(
              onPanEnd: _onPanEnd,
              behavior: HitTestBehavior.opaque,
              child: StudentCard(profile: _profiles[_currentIndex]),
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
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text("Viste todos os estudantes compatíveis."),
        ],
      ),
    );
  }
}
