import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// Indicador visual de arrastar para bottom sheets.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.indicatorInactive,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
