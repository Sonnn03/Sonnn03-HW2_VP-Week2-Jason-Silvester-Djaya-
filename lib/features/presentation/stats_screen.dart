import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/presentation/widgets/episode_progress.dart';
import 'package:homework2/features/presentation/widgets/stat_tile.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.dramas});

  final List<Drama> dramas;

  static String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    return '$hours jam $rest mnt';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik tontonan')),
      body: SafeArea(
        top: false,
        child: dramas.isEmpty ? const _EmptyStats() : _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final finished = dramas.where((d) => d.isFinished).length;
    final notStarted = dramas.where((d) => d.watchedEpisodes == 0).length;
    final inProgress =
        dramas.where((d) => !d.isFinished && d.watchedEpisodes > 0).toList();
    final episodes = dramas.fold<int>(0, (sum, d) => sum + d.watchedEpisodes);
    final minutes = dramas.fold<int>(0, (sum, d) => sum + d.watchedMinutes);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        final available = constraints.maxWidth - AppSpacing.md * 2;
        final tileWidth =
            (available - AppSpacing.md * (columns - 1)) / columns;

        Widget tile(IconData icon, String value, String label) => SizedBox(
              width: tileWidth,
              child: StatTile(icon: icon, value: value, label: label),
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  tile(Icons.schedule, _formatDuration(minutes),
                      'Total waktu tonton'),
                  tile(Icons.tv, '$episodes', 'Episode ditonton'),
                  tile(Icons.check_circle_outline, '$finished', 'Selesai'),
                  tile(Icons.play_circle_outline, '${inProgress.length}',
                      'Sedang ditonton'),
                  tile(Icons.bookmark_border, '$notStarted', 'Belum mulai'),
                ],
              ),
              if (inProgress.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('Sedang ditonton', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                for (final drama in inProgress) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drama.title,
                            style: textTheme.titleMedium,
                            maxLines: 2,
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
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart,
                size: AppSpacing.xxl, color: colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Belum ada data untuk dihitung',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tambahkan drama ke watchlist untuk melihat statistik.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}