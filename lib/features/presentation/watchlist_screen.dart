import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_spacing.dart';
import 'package:homework2/features/presentation/widgets/drama_detail_screen.dart';

import '../data/drama_repository.dart';
import '../models/drama.dart';
import 'widgets/drama_card.dart';
import 'widgets/tag_filter_chips.dart';
import 'widgets/watchlist_empty_state.dart';
import 'widgets/watchlist_loading.dart';
import 'widgets/watchlist_search_bar.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({
    super.key,
    this.repository = const DramaRepository(),
  });

  final DramaRepository repository;

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Drama> _dramas = const [];
  bool _isLoading = true;
  String _query = '';
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await widget.repository.fetchDramas();
    if (!mounted) return;
    setState(() {
      _dramas = result;
      _isLoading = false;
    });
  }

  void _reload() {
    setState(() => _isLoading = true);
    _load();
  }

  List<String> get _allTags {
    final tags = <String>{for (final d in _dramas) ...d.tags};
    return tags.toList()..sort();
  }

  bool get _hasFilters => _query.isNotEmpty || _selectedTag != null;

  List<Drama> get _visibleDramas {
    final query = _query.toLowerCase();
    return _dramas.where((d) {
      final matchesQuery = d.title.toLowerCase().contains(query);
      final matchesTag = _selectedTag == null || d.tags.contains(_selectedTag);
      return matchesQuery && matchesTag;
    }).toList();
  }

  void _onQueryChanged(String value) => setState(() => _query = value.trim());

  void _onTagSelected(String? tag) => setState(() => _selectedTag = tag);

  void _onEpisodeWatched(String id) {
    setState(() {
      _dramas = [
        for (final d in _dramas)
          if (d.id == id && !d.isFinished)
            d.copyWith(watchedEpisodes: d.watchedEpisodes + 1)
          else
            d,
      ];
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedTag = null;
    });
  }

  void _openDetail(Drama drama) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DramaDetailScreen(
          drama: drama,
          allDramas: _dramas,
          onEpisodeWatched: _onEpisodeWatched,
          repository: widget.repository,
        ),
      ),
    );
  }

  int _columnsFor(double width) {
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Drama Watchlist')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = _columnsFor(constraints.maxWidth);
            return CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: WatchlistSearchBar(
                      controller: _searchController,
                      onChanged: _onQueryChanged,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: TagFilterChips(
                    tags: _allTags,
                    selectedTag: _selectedTag,
                    onSelected: _onTagSelected,
                  ),
                ),
                ..._buildContent(columns),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildContent(int columns) {
    if (_isLoading) {
      return const [
        SliverFillRemaining(hasScrollBody: false, child: WatchlistLoading()),
      ];
    }

    final dramas = _visibleDramas;
    if (dramas.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: WatchlistEmptyState(
            hasFilters: _hasFilters,
            onClearFilters: _clearFilters,
            onReload: _reload,
          ),
        ),
      ];
    }

    Widget cardAt(int index) {
      final drama = dramas[index];
      return DramaCard(
        drama: drama,
        onTap: () => _openDetail(drama),
        onEpisodeWatched: () => _onEpisodeWatched(drama.id),
      );
    }

    if (columns == 1) {
      return [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: dramas.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => cardAt(index),
          ),
        ),
      ];
    }

    final textScale =
        math.max(1.0, MediaQuery.textScalerOf(context).scale(16) / 16);
    return [
      SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            mainAxisExtent: 176 * textScale,
          ),
          itemCount: dramas.length,
          itemBuilder: (context, index) => cardAt(index),
        ),
      ),
    ];
  }
}