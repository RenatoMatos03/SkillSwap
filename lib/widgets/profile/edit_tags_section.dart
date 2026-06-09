import 'package:flutter/material.dart';
import '../../theme/app_tokens.dart';
import '../labeled_text_field.dart';
import 'profile_section_card.dart';

class EditTagsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tags;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onAdd;
  final void Function(String) onRemove;

  const EditTagsSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.controller,
    required this.hintText,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      title: title,
      subtitle: subtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tags.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag,
                            style: const TextStyle(
                                color: AppColors.primary, fontSize: 13)),
                        backgroundColor: AppColors.surfaceMint,
                        side: const BorderSide(color: AppColors.chipBorder),
                        deleteIcon: const Icon(Icons.close,
                            size: 16, color: AppColors.primary),
                        onDeleted: () => onRemove(tag),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LabeledTextField(
                  controller: controller,
                  hint: hintText,
                  onSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
