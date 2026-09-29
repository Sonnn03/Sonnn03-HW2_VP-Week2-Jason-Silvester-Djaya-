import 'package:flutter/material.dart';

class WatchlistLoading extends StatelessWidget {
  const WatchlistLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(semanticsLabel: 'Memuat watchlist'),
    );
  }
}