import 'package:flutter/material.dart';
import '../../theme/app_tokens.dart';
import '../../utils/string_utils.dart';

/// Avatar circular do utilizador com fallback para iniciais quando não há foto.
class ProfileAvatar extends StatelessWidget {
  final String name;
  final String photoUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
    this.radius = 44,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryDark,
      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
      onBackgroundImageError: photoUrl.isNotEmpty ? (_, _) {} : null,
      child: photoUrl.isEmpty
          ? Text(
              getInitials(name),
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
