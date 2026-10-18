import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/models/review.dart';
import 'package:homework2/features/presentation/widgets/rating_stars.dart';

class ReviewSection extends StatelessWidget {
  const ReviewSection({super.key, required this.future});

  final Future<List<Review>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final reviews = snapshot.data ?? const <Review>[];
        if (reviews.isEmpty) {
          return const Text('Belum ada review.');
        }
        return Column(
          children: [
            for (final review in reviews) ...[
              _ReviewCard(review: review),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Text(
                    review.author.isEmpty ? '?' : review.author[0],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.author,
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        review.date,
                        style: textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                RatingStars(rating: review.rating),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              review.comment,
              style: textTheme.bodyMedium,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}