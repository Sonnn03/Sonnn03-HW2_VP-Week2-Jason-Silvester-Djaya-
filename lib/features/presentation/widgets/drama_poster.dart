import 'package:flutter/material.dart';

class DramaPoster extends StatelessWidget {
  const DramaPoster({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 12,
  });

  final String url;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget placeholder(IconData icon) => ColoredBox(
          color: colors.surfaceContainerHighest,
          child: Center(child: Icon(icon, color: colors.onSurfaceVariant)),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : placeholder(Icons.image_outlined),
          errorBuilder: (context, error, stack) =>
              placeholder(Icons.movie_outlined),
        ),
      ),
    );
  }
}