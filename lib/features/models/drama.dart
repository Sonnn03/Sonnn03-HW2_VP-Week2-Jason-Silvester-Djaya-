class Drama {
  const Drama({
    required this.id,
    required this.title,
    required this.origin,
    required this.tags,
    required this.totalEpisodes,
    this.watchedEpisodes = 0,
  });

  final String id;
  final String title;
  final String origin;
  final List<String> tags;
  final int totalEpisodes;
  final int watchedEpisodes;

  bool get isFinished => watchedEpisodes >= totalEpisodes;

  double get progress =>
      totalEpisodes == 0 ? 0 : watchedEpisodes / totalEpisodes;

  Drama copyWith({int? watchedEpisodes}) {
    return Drama(
      id: id,
      title: title,
      origin: origin,
      tags: tags,
      totalEpisodes: totalEpisodes,
      watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
    );
  }
}