import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_tokens.dart';

class AppBalanceChip extends StatelessWidget {
  final VoidCallback? onTap;

  const AppBalanceChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: currentUser != null 
          ? FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots()
          : const Stream.empty(),
      builder: (context, snapshot) {
        
        String displayValue = '0';
        
        // Se houver dados, atualizamos o valor a mostrar
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          displayValue = (data['coins'] ?? 0).toString();
        }

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Semantics(
            label: 'Saldo atual $displayValue',
            button: onTap != null,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.copyright, size: 18, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    displayValue,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class AppUserAvatar extends StatelessWidget {
  final String initials;
  final String photoUrl;
  final VoidCallback? onTap;

  const AppUserAvatar({
    super.key,
    this.initials = '',
    this.photoUrl = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: AppColors.primaryDark,
          backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
          onBackgroundImageError: photoUrl.isNotEmpty ? (_, __) {} : null,
          child: photoUrl.isEmpty
              ? Text(
                  initials,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                )
              : null,
        ),
      ),
    );
  }
}