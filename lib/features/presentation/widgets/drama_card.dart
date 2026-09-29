import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';

import '../../models/drama.dart';
import 'episode_progress.dart';

class DramaCard extends StatelessWidget {
  const DramaCard({
    super.key,
    required this.drama,
    required this.onEpisodeWatched,
  });

  final Drama drama;
  final VoidCallback onEpisodeWatched;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drama.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    drama.origin,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    drama.tags.join(' • '),
                    style: textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  EpisodeProgress(
                    watched: drama.watchedEpisodes,
                    total: drama.totalEpisodes,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              tooltip: drama.isFinished
                  ? 'Sudah selesai'
                  : 'Tandai 1 episode ditonton',
              onPressed: drama.isFinished ? null : onEpisodeWatched,
              icon: Icon(
                drama.isFinished
                    ? Icons.check_circle
                    : Icons.add_circle_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}