import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class AppBalanceChip extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;

  const AppBalanceChip({super.key, this.value = '100 €', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Semantics(
        label: 'Saldo atual $value',
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
                value,
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
}

class AppUserAvatar extends StatelessWidget {
  final String initials;
  final VoidCallback? onTap;

  const AppUserAvatar({super.key, this.initials = 'RM', this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: AppColors.primaryDark,
          child: Text(
            initials,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
