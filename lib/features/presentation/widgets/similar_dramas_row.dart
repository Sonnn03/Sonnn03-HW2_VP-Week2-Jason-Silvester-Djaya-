import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/presentation/widgets/drama_poster.dart';

class SimilarDramasRow extends StatelessWidget {
  const SimilarDramasRow({
    super.key,
    required this.dramas,
    required this.onTap,
  });

  final List<Drama> dramas;
  final ValueChanged<Drama> onTap;

  @override
  Widget build(BuildContext context) {
    final textScale =
        math.max(1.0, MediaQuery.textScalerOf(context).scale(16) / 16);

    return SizedBox(
      // Tinggi ikut text scale supaya tidak overflow saat font diperbesar.
      height: 232 * textScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dramas.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = dramas[index];
          return _SimilarDramaItem(drama: item, onTap: () => onTap(item));
        },
      ),
    );
  }
}

class _SimilarDramaItem extends StatelessWidget {
  const _SimilarDramaItem({required this.drama, required this.onTap});

  final Drama drama;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 120,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DramaPoster(url: drama.posterUrl, width: 120, height: 168),
            const SizedBox(height: AppSpacing.sm),
            Text(
              drama.title,
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}