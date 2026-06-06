import 'package:flutter/material.dart';

import '../quiz/quiz_home_view.dart';
import 'about_us_page.dart';
import '../../widgets/drawer_menu_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _newsIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _newsPageController = PageController(
    viewportFraction: 0.92,
  );

  @override
  void dispose() {
    _newsPageController.dispose();
    super.dispose();
  }

  final List<_NewsItem> _newsItems = const [
    _NewsItem(
      tag: 'QUIZ',
      title: 'Quiz desta semana: Bases de Dados',
      subtitle:
          'Testa os teus conhecimentos sobre SQL, normalização e transações.',
      date: '18 May 2026',
    ),
    _NewsItem(
      tag: 'PARCERIA',
      title: 'Nova parceria com o Instituto Politécnico de Setúbal',
      subtitle: 'Mais oportunidades e apoio para os teus projetos académicos.',
      date: '19 May 2026',
    ),
    _NewsItem(
      tag: 'SISTEMA',
      title: 'Sistema de moedas recebeu uma atualização',
      subtitle: 'Dobra de moedas semanal e novas recompensas disponíveis.',
      date: '20 May 2026',
    ),
  ];

  final List<_LeaderboardItem> _leaderboardItems = const [
    _LeaderboardItem(
      title: 'Top 10 — Mais Moedas',
      subtitle: 'Ranking geral de moedas acumuladas',
      icon: Icons.workspace_premium_outlined,
    ),
    _LeaderboardItem(
      title: 'Top 10 — Quiz Semanal',
      subtitle: 'Melhores resultados da semana',
      icon: Icons.emoji_events_outlined,
    ),
  ];

  final List<Widget> _pages = const [
    SizedBox.shrink(),
    Center(child: Text('Match Content')),
    Center(child: Text('Mensagens Content')),
    Center(child: Text('Fórum Content')),
    QuizHomeView(),
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
          InkWell(
            onTap: () => _showInfoSheet(
              title: 'Saldo SkillSwap',
              message:
                  'Tens 100 € disponíveis para trocar ou usar em funcionalidades futuras.',
            ),
            borderRadius: BorderRadius.circular(20),
            child: Container(
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
          ),
          InkWell(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            borderRadius: BorderRadius.circular(999),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Color(0xFF006064),
                child: Text(
                  "RM",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _pages[_selectedIndex],
      // Navbar Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF009191),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Match'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Mensagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Fórum',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Quiz',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF009191),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF009191).withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Olá, Maria Rodrigues 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orangeAccent,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '3 semanas consecutivas de ajuda!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notícias',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D204B),
                  ),
                ),
                TextButton(
                  onPressed: _showAllNewsSheet,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Ver Todas',
                    style: TextStyle(
                      color: Color(0xFF009191),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: PageView.builder(
                itemCount: _newsItems.length,
                controller: _newsPageController,
                onPageChanged: (index) => setState(() => _newsIndex = index),
                itemBuilder: (context, index) {
                  final item = _newsItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _NewsCard(
                      item: item,
                      onTap: () => _openNewsItem(item),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _newsItems.length,
                (index) => GestureDetector(
                  onTap: () => _newsPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: index == _newsIndex ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: index == _newsIndex
                          ? const Color(0xFF009191)
                          : const Color(0xFFD5E7E6),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Leaderboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D204B),
              ),
            ),
            const SizedBox(height: 10),
            ..._leaderboardItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LeaderboardCard(
                  item: item,
                  onTap: () => _showLeaderboardDetails(item),
                ),
              ),
            ),
          ],
        ),
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
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF006064),
                  child: const Text(
                    "RM",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Renato Matos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "LEI · 2º Ano",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          _buildLightDivider(),
          DrawerMenuItem(
            icon: Icons.person_outline,
            title: "Ver Perfil",
            onTap: () => _showInfoSheet(
              title: 'Perfil',
              message:
                  'A página de perfil ainda não está pronta. Esta opção já responde ao toque.',
            ),
          ),
          _buildLightDivider(),
          DrawerMenuItem(
            icon: Icons.history,
            title: "Histórico",
            onTap: () => _showInfoSheet(
              title: 'Histórico',
              message:
                  'O histórico será ligado a uma página própria numa próxima fase.',
            ),
          ),
          _buildLightDivider(),
          DrawerMenuItem(
            icon: Icons.settings_outlined,
            title: "Definições",
            onTap: () => _showInfoSheet(
              title: 'Definições',
              message:
                  'As definições ainda estão em construção, mas o item já é clicável.',
            ),
          ),
          _buildLightDivider(),
          DrawerMenuItem(
            icon: Icons.info_outline,
            title: "About Us",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsPage()));
            },
          ),
          _buildLightDivider(),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "SkillSwap · v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _openNewsItem(_NewsItem item) {
    if (item.tag == 'QUIZ') {
      setState(() => _selectedIndex = 4);
      return;
    }

    _showInfoSheet(title: item.title, message: item.subtitle);
  }

  void _showLeaderboardDetails(_LeaderboardItem item) {
    _showInfoSheet(title: item.title, message: item.subtitle);
  }

  void _showInfoSheet({required String title, required String message}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5E7E6),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D204B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5F6368),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009191),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Fechar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAllNewsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5E7E6),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Todas as notícias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D204B),
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _newsItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _newsItems[index];
                      return _NewsCard(
                        item: item,
                        onTap: () {
                          Navigator.pop(context);
                          _openNewsItem(item);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009191),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Fechar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLightDivider() {
    return const Column(
      children: [
        SizedBox(height: 6),
        Divider(color: Color(0xFFF1F4F5), thickness: 1),
        SizedBox(height: 6),
      ],
    );
  }
}

class _NewsItem {
  final String tag;
  final String title;
  final String subtitle;
  final String date;

  const _NewsItem({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.date,
  });
}

class _LeaderboardItem {
  final String title;
  final String subtitle;
  final IconData icon;

  const _LeaderboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class _NewsCard extends StatelessWidget {
  final _NewsItem item;
  final VoidCallback onTap;

  const _NewsCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EAEE)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.tag,
                      style: const TextStyle(
                        color: Color(0xFF009191),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    item.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D204B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF5F6368),
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final _LeaderboardItem item;
  final VoidCallback onTap;

  const _LeaderboardCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE6EAEE)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: const Color(0xFF009191)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D204B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
