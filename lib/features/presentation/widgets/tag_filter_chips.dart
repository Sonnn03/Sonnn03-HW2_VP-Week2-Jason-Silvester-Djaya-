import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';


class TagFilterChips extends StatelessWidget {
  const TagFilterChips({
    super.key,
    required this.tags,
    required this.selectedTag,
    required this.onSelected,
  });

  final List<String> tags;
  final String? selectedTag;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: tags.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return FilterChip(
            label: Text(tag),
            selected: tag == selectedTag,
            onSelected: (isSelected) => onSelected(isSelected ? tag : null),
          );
        },
      ),
    );
  }
}