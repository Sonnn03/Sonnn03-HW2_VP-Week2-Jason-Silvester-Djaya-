import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/data/drama_repository.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/models/review.dart';
import 'package:homework2/features/presentation/widgets/drama_poster.dart';
import 'package:homework2/features/presentation/widgets/drama_poster_app_bar.dart';
import 'package:homework2/features/presentation/widgets/drama_summary.dart';
import 'package:homework2/features/presentation/widgets/episode_progress.dart';
import 'package:homework2/features/presentation/widgets/expandable_text.dart';
import 'package:homework2/features/presentation/widgets/review_selection.dart';
import 'package:homework2/features/presentation/widgets/similar_dramas_row.dart';

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
  static const double _wideBreakpoint = 720;

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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
  }

  void _openSimilar(Drama item) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DramaDetailScreen(
          drama: item,
          allDramas: widget.allDramas,
          onEpisodeWatched: widget.onEpisodeWatched,
          repository: widget.repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final similar = widget.repository.similarTo(_drama, widget.allDramas);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _wideBreakpoint;
        return Scaffold(
          appBar: isWide
              ? AppBar(
                  title: Text(
                    _drama.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : null,
          body: SafeArea(
            top: false,
            child: isWide
                ? _buildWide(similar)
                : _buildNarrow(constraints, similar),
          ),
        );
      },
    );
  }

  Widget _buildNarrow(BoxConstraints constraints, List<Drama> similar) {
    final headerHeight = (constraints.maxHeight * 0.45).clamp(160.0, 360.0);

    return CustomScrollView(
      slivers: [
        DramaPosterAppBar(
          url: _drama.posterUrl,
          expandedHeight: headerHeight,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildInfo(similar),
          ),
        ),
      ],
    );
  }

  Widget _buildWide(List<Drama> similar) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 280,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: DramaPoster(url: _drama.posterUrl),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: _buildInfo(similar)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(List<Drama> similar) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DramaSummary(drama: _drama),
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
              _drama.isFinished ? 'Sudah selesai' : 'Tandai 1 episode ditonton',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Sinopsis', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        ExpandableText(
          text: _drama.synopsis,
          style: textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Review', style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        ReviewSection(future: _reviews),
        if (similar.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Drama serupa', style: textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          SimilarDramasRow(dramas: similar, onTap: _openSimilar),
        ],
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}