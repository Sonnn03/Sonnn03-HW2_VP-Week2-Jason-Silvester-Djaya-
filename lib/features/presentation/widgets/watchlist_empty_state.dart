import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
    required this.onReload,
  });

  final bool hasFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.movie_outlined,
              size: AppSpacing.lg * 2,
              color: colors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              hasFilters ? 'Drama tidak ditemukan' : 'Watchlist masih kosong',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasFilters
                  ? 'Coba kata kunci atau tag lain.'
                  : 'Belum ada drama yang bisa ditampilkan.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.md),
            if (hasFilters)
              FilledButton.tonal(
                onPressed: onClearFilters,
                child: const Text('Reset pencarian'),
              )
            else
              FilledButton.tonalIcon(
                onPressed: onReload,
                icon: const Icon(Icons.refresh),
                label: const Text('Muat ulang'),
              ),
          ],
        ),
      ),
    );
  }
}