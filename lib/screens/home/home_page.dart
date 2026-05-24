import 'package:flutter/material.dart';

import '../quiz/quiz_home_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const Center(child: Text("Home Content")),
    const Center(child: Text("Match Content")),
    const Center(child: Text("Mensagens Content")),
    const Center(child: Text("Fórum Content")),
    const QuizHomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // Menu Lateral
      drawer: _buildDrawer(),
      // Navbar Superior
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1D204B)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // Moedas/Saldo
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.copyright, size: 18, color: Color(0xFF009191)),
                SizedBox(width: 6),
                Text(
                  "100 €",
                  style: TextStyle(
                    color: Color(0xFF009191),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Avatar do Utilizador
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF006064),
              child: const Text("RM", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_selectedIndex],
      // Navbar Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF009191),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Match'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Mensagens'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Fórum'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Quiz'),
        ],
      ),
    );
  }

  // Widget do Menu Lateral
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF006064),
                  child: const Text("RM", style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Renato Matos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("LEI · 2º Ano", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          _buildLightDivider(),
          _drawerItem(Icons.person_outline, "Ver Perfil"),
          _buildLightDivider(),
          _drawerItem(Icons.history, "Histórico"),
          _buildLightDivider(),
          _drawerItem(Icons.settings_outlined, "Definições"),
          _buildLightDivider(),
          _drawerItem(Icons.info_outline, "About Us"),
          _buildLightDivider(),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("SkillSwap · v1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF009191)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildLightDivider() {
    return const Column(
      children: [
        SizedBox(height: 6),
        Divider(
          color: Color(0xFFF1F4F5),
          thickness: 1,
        ),
        SizedBox(height: 6),
      ],
    );
  }
}