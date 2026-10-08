import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';
import 'package:homework2/features/data/drama_repository.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/models/review.dart';
import 'package:homework2/features/presentation/widgets/drama_poster.dart';
import 'package:homework2/features/presentation/widgets/episode_progress.dart';
import 'package:homework2/features/presentation/widgets/rating_stars.dart';

class DramaDetailScreen extends StatefulWidget {
  const DramaDetailScreen({
    super.key,
    required this.drama,
    required this.allDramas,
    required this.onEpisodeWatched,
    this.repository = const DramaRepository(),
  });

  final Drama drama;
  final List<Drama> allDramas;
  final void Function(String id) onEpisodeWatched;
  final DramaRepository repository;

  @override
  State<DramaDetailScreen> createState() => _DramaDetailScreenState();
}

class _DramaDetailScreenState extends State<DramaDetailScreen> {
  late Drama _drama;
  late final Future<List<Review>> _reviews;

  @override
  void initState() {
    super.initState();
    _drama = widget.drama;
    _reviews = widget.repository.fetchReviews(_drama.id);
  }

  void _markWatched() {
    if (_drama.isFinished) return;
    setState(() {
      _drama = _drama.copyWith(watchedEpisodes: _drama.watchedEpisodes + 1);
    });
    widget.onEpisodeWatched(_drama.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Episode ${_drama.watchedEpisodes} ditandai ditonton',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final similar = widget.repository.similarTo(_drama, widget.allDramas);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  DramaPoster(url: _drama.posterUrl, radius: 0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, colors.surface],
                        stops: const [0.55, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Elemen utama layar ini: judul.
                  Text(
                    _drama.title,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _drama.origin,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      RatingStars(rating: _drama.rating, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _drama.rating.toStringAsFixed(1),
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final tag in _drama.tags) Chip(label: Text(tag)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  EpisodeProgress(
                    watched: _drama.watchedEpisodes,
                    total: _drama.totalEpisodes,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _drama.isFinished ? null : _markWatched,
                      icon: Icon(
                        _drama.isFinished
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                      ),
                      label: Text(
                        _drama.isFinished
                            ? 'Sudah selesai'
                            : 'Tandai 1 episode ditonton',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Sinopsis', style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _drama.synopsis,
                    style: textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Review', style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  _ReviewSection(future: _reviews),
                  if (similar.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text('Drama serupa', style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 230,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: similar.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final item = similar[index];
                          return _SimilarDramaItem(
                            drama: item,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => DramaDetailScreen(
                                  drama: item,
                                  allDramas: widget.allDramas,
                                  onEpisodeWatched: widget.onEpisodeWatched,
                                  repository: widget.repository,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.future});

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
                  child: Text(review.author[0]),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.author, style: textTheme.titleSmall),
                      Text(
                        review.date,
                        style: textTheme.bodySmall
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                RatingStars(rating: review.rating),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(review.comment, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SimilarDramaItem extends StatelessWidget {
  const _SimilarDramaItem({required this.drama, required this.onTap});

  final Drama drama;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 120,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DramaPoster(url: drama.posterUrl, width: 120, height: 170),
            const SizedBox(height: AppSpacing.sm),
            Text(
              drama.title,
              style: textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}