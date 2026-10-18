import 'package:flutter/material.dart';
import 'package:homework2/core/theme/app_theme.dart';
import 'package:homework2/features/data/drama_repository.dart';
import 'package:homework2/features/presentation/watchlist_screen.dart';

const DramaScenario _scenario = DramaScenario.normal;

void main() => runApp(const DramaWatchlistApp());

class DramaWatchlistApp extends StatelessWidget {
  const DramaWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drama Watchlist',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const WatchlistScreen(
        repository: DramaRepository(scenario: _scenario),
      ),
    );
  }
}