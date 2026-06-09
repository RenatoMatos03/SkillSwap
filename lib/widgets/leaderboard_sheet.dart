import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';
import '../utils/string_utils.dart';

class LeaderboardSheet extends StatelessWidget {
  final String title;
  final String field;
  final String valueSuffix;
  final IconData icon;

  const LeaderboardSheet({
    super.key,
    required this.title,
    required this.field,
    required this.valueSuffix,
    required this.icon,
  });

  Future<List<Map<String, dynamic>>> _fetchTop5() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy(field, descending: true)
        .limit(5)
        .get();
    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchTop5(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text('Nenhum resultado ainda.',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
                );
              }
              final users = snapshot.data!;
              return Column(
                children: List.generate(users.length, (i) {
                  final user = users[i];
                  final name = user['name'] ?? '';
                  final photoUrl = user['photoUrl'] ?? '';
                  final value = user[field] ?? 0;
                  return _LeaderboardRow(
                    rank: i + 1,
                    name: name,
                    photoUrl: photoUrl,
                    value: value,
                    valueSuffix: valueSuffix,
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final int rank;
  final String name;
  final String photoUrl;
  final int value;
  final String valueSuffix;

  const _LeaderboardRow({
    required this.rank,
    required this.name,
    required this.photoUrl,
    required this.value,
    required this.valueSuffix,
  });

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFB0BEC5);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _rankColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryDark,
            backgroundImage:
                photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            child: photoUrl.isEmpty
                ? Text(
                    getInitials(name),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$value $valueSuffix',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
