import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../services/user_service.dart';
import '../../theme/app_tokens.dart';
import '../quiz/quiz_home_view.dart';
import 'about_us_page.dart';
import 'home_mock_data.dart';
import 'home_models.dart';
import '../forum/forum_schools_page.dart';
import '../swipe/swipe_page.dart';
import '../../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _newsIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _newsPageController = PageController(viewportFraction: 0.92);
  final _userService = UserService();

  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _userService.getUserProfile();
    if (mounted) setState(() => _profile = profile);
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return parts.isNotEmpty && parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  String _getStreakText(int streak) {
    if (streak == 0) return 'Começa hoje a tua streak!';
    return '$streak semana${streak == 1 ? '' : 's'} consecutiva${streak == 1 ? '' : 's'}!';
  }

  @override
  void dispose() {
    _newsPageController.dispose();
    super.dispose();
  }

  final List<NewsItem> _newsItems = homeNewsItems;
  final List<LeaderboardItem> _leaderboardItems = homeLeaderboardItems;

  final List<Widget> _pages = [
    const SizedBox.shrink(),
    SwipePage(),
    const Center(child: Text('Mensagens Content')),
    ForumSchoolsPage(),
    const QuizHomeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.cardBackground,
      // Menu Lateral
      drawer: _buildDrawer(),
      // Navbar Superior
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          tooltip: 'Abrir menu',
        ),
        actions: [
          AppBalanceChip(
            value: '${_profile?.coins ?? 0}',
            onTap: () => _showInfoSheet(
              title: 'Saldo SkillSwap',
              message: 'Tens ${_profile?.coins ?? 0} coins disponíveis.',
            ),
          ),
          AppUserAvatar(
            initials: _getInitials(_profile?.name ?? ''),
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
            HomeGreetingCard(
              greeting: 'Olá, ${_profile?.name.split(' ').first ?? 'utilizador'} 👋',
              streakText: _getStreakText(_profile?.streak ?? 0),
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
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _showAllNewsSheet,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Ver Todas',
                    style: TextStyle(
                      color: AppColors.primary,
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
                    child: HomeNewsCard(
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
                          ? AppColors.primary
                          : AppColors.indicatorInactive,
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ..._leaderboardItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HomeLeaderboardCard(
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
      backgroundColor: AppColors.cardBackground,
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
                  backgroundColor: AppColors.primaryDark,
                  child: Text(
                    _getInitials(_profile?.name ?? ''),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _profile?.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _profile != null ? '${_profile!.course} · ${_profile!.academicYear}' : '',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Fechar menu',
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
            title: 'Sobre Nós',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
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

  void _openNewsItem(NewsItem item) {
    if (item.tag == 'QUIZ') {
      setState(() => _selectedIndex = 4);
      return;
    }

    _showInfoSheet(title: item.title, message: item.subtitle);
  }

  void _showLeaderboardDetails(LeaderboardItem item) {
    _showInfoSheet(title: item.title, message: item.subtitle);
  }

  void _showInfoSheet({required String title, required String message}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
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
              const SheetHandle(),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              const SheetCloseButton(),
            ],
          ),
        );
      },
    );
  }

  void _showAllNewsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
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
                const SheetHandle(),
                const SizedBox(height: 16),
                const Text(
                  'Todas as notícias',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                      return HomeNewsCard(
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
                const SheetCloseButton(),
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
        Divider(color: AppColors.dividerLight, thickness: 1),
        SizedBox(height: 6),
      ],
    );
  }
}
