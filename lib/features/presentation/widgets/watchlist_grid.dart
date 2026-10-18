import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/presentation/widgets/drama_card.dart';

/// Sliver berisi daftar (1 kolom) atau grid (>= 2 kolom) kartu drama.
class WatchlistGrid extends StatelessWidget {
  const WatchlistGrid({
    super.key,
    required this.dramas,
    required this.columns,
    required this.onTap,
    required this.onEpisodeWatched,
  });

  final List<Drama> dramas;
  final int columns;
  final ValueChanged<Drama> onTap;
  final ValueChanged<String> onEpisodeWatched;

  Widget _cardAt(int index) {
    final drama = dramas[index];
    return DramaCard(
      drama: drama,
      onTap: () => onTap(drama),
      onEpisodeWatched: () => onEpisodeWatched(drama.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (columns == 1) {
      return SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverList.separated(
          itemCount: dramas.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _cardAt(index),
        ),
      );
    }

    final textScale =
        math.max(1.0, MediaQuery.textScalerOf(context).scale(16) / 16);
    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.md),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          mainAxisExtent: 176 * textScale,
        ),
        itemCount: dramas.length,
        itemBuilder: (context, index) => _cardAt(index),
      ),
    );
  }
}