import 'package:flutter/material.dart';
import 'package:homework2/features/presentation/widgets/drama_poster.dart';

/// SliverAppBar dengan poster besar (layout sempit) di layar detail.
class DramaPosterAppBar extends StatelessWidget {
  const DramaPosterAppBar({
    super.key,
    required this.url,
    required this.expandedHeight,
  });

  final String url;
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      // Lingkaran semi-transparan agar tombol back terbaca di atas poster
      // pada light maupun dark mode.
      leading: BackButton(
        style: IconButton.styleFrom(
          backgroundColor: colors.surface.withValues(alpha: 0.7),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            DramaPoster(url: url, radius: 0),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.surface.withValues(alpha: 0),
                    colors.surface,
                  ],
                  stops: const [0.55, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}