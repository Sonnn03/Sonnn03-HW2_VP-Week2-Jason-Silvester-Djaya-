import 'package:flutter/material.dart';

class WatchlistSearchBar extends StatelessWidget {
  const WatchlistSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      hintText: 'Cari judul drama',
      leading: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}