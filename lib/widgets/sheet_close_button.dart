import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

/// Botão de fecho para bottom sheets.
class SheetCloseButton extends StatelessWidget {
  final String label;

  const SheetCloseButton({super.key, this.label = 'Fechar'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
