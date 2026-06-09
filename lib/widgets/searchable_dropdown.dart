import 'package:flutter/material.dart';

const _kFieldColor = Color(0xFFF2F5F7);
const _kPrimary = Color(0xFF009191);

class SearchableDropdown<T extends Object> extends StatelessWidget {
  final String label;
  final List<T> options;
  final String Function(T) display;
  final String Function(T) subtitle;
  final void Function(T) onSelected;
  final void Function() onCleared;
  final String hint;
  final bool enabled;
  final bool loading;
  final bool isSelected;
  final String? initialValue;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.display,
    required this.subtitle,
    required this.onSelected,
    required this.onCleared,
    required this.hint,
    this.enabled = true,
    this.loading = false,
    this.isSelected = false,
    this.initialValue,
  });

  InputDecoration _decoration(String hintText, {Widget? suffixIcon, Color? fillColor}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: fillColor ?? _kFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        suffixIcon: suffixIcon,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Autocomplete<T>(
          initialValue: initialValue != null
              ? TextEditingValue(text: initialValue!)
              : null,
          displayStringForOption: display,
          optionsBuilder: (value) {
            if (options.isEmpty) return const [];
            if (value.text.isEmpty) return options;
            final q = value.text.toLowerCase();
            return options.where(
              (item) =>
                  display(item).toLowerCase().contains(q) ||
                  subtitle(item).toLowerCase().contains(q),
            );
          },
          onSelected: onSelected,
          fieldViewBuilder: (context, controller, focusNode, _) => TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            onChanged: (_) => onCleared(),
            decoration: _decoration(
              loading ? 'A carregar...' : hint,
              fillColor: enabled ? _kFieldColor : const Color(0xFFEEEEEE),
              suffixIcon: loading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _kPrimary,
                        ),
                      ),
                    )
                  : isSelected
                      ? const Icon(Icons.check_circle, color: _kPrimary, size: 20)
                      : null,
            ),
          ),
          optionsViewBuilder: (context, onSelect, opts) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    shrinkWrap: true,
                    itemCount: opts.length,
                    itemBuilder: (context, i) {
                      final opt = opts.elementAt(i);
                      return InkWell(
                        onTap: () => onSelect(opt),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(display(opt),
                                  style: const TextStyle(
                                      fontSize: 14, color: Color(0xFF1D204B))),
                              Text(subtitle(opt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
