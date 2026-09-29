import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';

class EpisodeProgress extends StatelessWidget {
  const EpisodeProgress({
    super.key,
    required this.watched,
    required this.total,
  });

  final int watched;
  final int total;

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : watched / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: value),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$watched / $total episode',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}