import 'package:flutter/material.dart';
import 'package:homework2/core/app_spacing.dart';

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
  // All screen state lives here; child widgets only receive values + callbacks.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Drama Watchlist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: WatchlistSearchBar(
              controller: _searchController,
              onChanged: _onQueryChanged,
            ),
          ),
          TagFilterChips(
            tags: _allTags,
            selectedTag: _selectedTag,
            onSelected: _onTagSelected,
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const WatchlistLoading();

    final dramas = _visibleDramas;
    if (dramas.isEmpty) {
      return WatchlistEmptyState(
        hasFilters: _hasFilters,
        onClearFilters: _clearFilters,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: dramas.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final drama = dramas[index];
        return DramaCard(
          drama: drama,
          onEpisodeWatched: () => _onEpisodeWatched(drama.id), onTap: () {  },
        );
      },
    );
  }
}