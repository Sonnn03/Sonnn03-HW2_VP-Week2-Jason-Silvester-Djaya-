import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: textTheme.headlineSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}