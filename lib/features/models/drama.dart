class Drama {
  const Drama({
    required this.id,
    required this.title,
    required this.origin,
    required this.tags,
    required this.totalEpisodes,
    required this.posterUrl,
    required this.synopsis,
    required this.rating,
    this.watchedEpisodes = 0,
  });

  final String id;
  final String title;
  final String origin;
  final List<String> tags;
  final int totalEpisodes;
  final String posterUrl;
  final String synopsis;

  /// Rating rata-rata skala 0-5.
  final double rating;
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
      posterUrl: posterUrl,
      synopsis: synopsis,
      rating: rating,
      watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
    );
  }
}