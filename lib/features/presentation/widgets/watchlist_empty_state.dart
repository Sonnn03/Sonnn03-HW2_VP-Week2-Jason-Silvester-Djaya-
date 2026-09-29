import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';


class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({
    super.key,
    required this.hasFilters,
    required this.onClearFilters,
  });

  final bool hasFilters;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
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
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              hasFilters
                  ? 'Coba kata kunci atau tag lain.'
                  : 'Tambahkan drama pertamamu.',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonal(
                onPressed: onClearFilters,
                child: const Text('Reset pencarian'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}