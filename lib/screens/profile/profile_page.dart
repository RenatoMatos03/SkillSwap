import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/profile/profile_widgets.dart';
import 'edit_profile_page.dart';

/// Ecrã de perfil do utilizador com separadores de informação e estatísticas.
class ProfilePage extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onProfileUpdated;
  final bool readOnly;

  const ProfilePage({
    super.key,
    required this.profile,
    this.onProfileUpdated,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              children: [
                _buildPerfilTab(),
                _buildEstatisticasTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        children: [
          if (!readOnly)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  tooltip: 'Editar perfil',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(
                        profile: profile,
                        onSaved: onProfileUpdated ?? () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ProfileAvatar(
            name: profile.name,
            photoUrl: profile.photoUrl,
            radius: 44,
          ),
          const SizedBox(height: 12),
          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '${profile.course} · ${profile.academicYear} · ${profile.school}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          const SizedBox(height: 10),
          _buildStarRating(profile.rating),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileStatChip(
                icon: Icons.local_fire_department,
                iconColor: Colors.orange,
                label: '${profile.streak} semana${profile.streak == 1 ? '' : 's'}',
              ),
              if (profile.showCoinsInProfile) ...[
                const SizedBox(width: 8),
                ProfileStatChip(
                  icon: Icons.copyright,
                  iconColor: Colors.white,
                  label: '${profile.coins} moedas',
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          ProfileStatChip(
            icon: Icons.handshake_outlined,
            iconColor: Colors.white,
            label: '${profile.helpsGiven} ajudas',
          ),
        ],
      ),
    );
  }

  /// Constrói a avaliação em estrelas com base na classificação média.
  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return const Icon(Icons.star, color: Colors.amber, size: 18);
          } else if (index < rating) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 18);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 18);
          }
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.primary,
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        tabs: [
          Tab(text: 'Perfil'),
          Tab(text: 'Estatísticas'),
        ],
      ),
    );
  }

  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionCard(
            title: 'Sobre Mim',
            child: Text(
              profile.bio.isNotEmpty ? profile.bio : 'Ainda não tens uma bio.',
              style: TextStyle(
                fontSize: 14,
                color: profile.bio.isNotEmpty ? AppColors.textSecondary : AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ProfileSectionCard(
            title: 'Domina',
            child: _buildTagWrap(profile.tagsOferta),
          ),
          const SizedBox(height: 14),
          ProfileSectionCard(
            title: 'À Procura de Ajuda',
            child: _buildTagWrap(profile.tagsProcura),
          ),
        ],
      ),
    );
  }

  Widget _buildEstatisticasTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  label: 'STREAK ATUAL',
                  value: '${profile.streak} sem.',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  label: 'AJUDAS DADAS',
                  value: '${profile.helpsGiven}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.emoji_events_outlined,
                  iconColor: AppColors.primary,
                  label: 'QUIZZES FEITOS',
                  value: '${profile.quizzesDone}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.copyright,
                  iconColor: Colors.amber,
                  label: 'MOEDAS GANHAS',
                  value: '${profile.coins}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagWrap(List<String> tags) {
    if (tags.isEmpty) {
      return const Text(
        'Nenhuma tag adicionada.',
        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => ProfileSkillChip(label: tag)).toList(),
    );
  }
}
