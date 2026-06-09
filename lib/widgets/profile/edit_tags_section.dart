import 'package:flutter/material.dart';
import '../custom_tag_input.dart';
import 'profile_section_card.dart';

/// Secção de edição de tags com campo de entrada e lista de chips removíveis.
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
                  .map((tag) => CustomTagChip(
                        label: tag,
                        onRemove: () => onRemove(tag),
                      ))
                  .toList(),
            ),
          const SizedBox(height: 12),
          CustomTagInputField(
            controller: controller,
            hintText: hintText,
            onAdd: onAdd,
          ),
        ],
      ),
    );
  }
}
