import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';

import '../../models/drama.dart';
import 'drama_poster.dart';
import 'episode_progress.dart';

class DramaCard extends StatelessWidget {
  const DramaCard({
    super.key,
    required this.drama,
    required this.onTap,
    required this.onEpisodeWatched,
  });

  final Drama drama;
  final VoidCallback onTap;
  final VoidCallback onEpisodeWatched;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DramaPoster(url: drama.posterUrl, width: 80, height: 120),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Elemen utama: judul (ukuran besar + tebal + warna onSurface).
                    Text(
                      drama.title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    // Info pendukung: peran warna onSurfaceVariant.
                    Text(
                      '${drama.origin}  ·  ★ ${drama.rating.toStringAsFixed(1)}',
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
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}