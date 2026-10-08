import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating; // 0-5
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final remaining = rating - i;
        final icon = remaining >= 0.75
            ? Icons.star
            : remaining >= 0.25
                ? Icons.star_half
                : Icons.star_border;
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}