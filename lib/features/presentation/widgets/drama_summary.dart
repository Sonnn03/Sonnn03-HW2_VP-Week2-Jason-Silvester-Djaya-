import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/presentation/widgets/rating_stars.dart';

/// Judul, asal, rating, dan tag sebuah drama di layar detail.
class DramaSummary extends StatelessWidget {
  const DramaSummary({super.key, required this.drama});

  final Drama drama;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Elemen utama layar ini: judul.
        Text(
          drama.title,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.onSurface,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          drama.origin,
          style:
              textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            RatingStars(rating: drama.rating, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              drama.rating.toStringAsFixed(1),
              style: textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final tag in drama.tags)
              Chip(
                label: Text(tag, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
          ],
        ),
      ],
    );
  }
}