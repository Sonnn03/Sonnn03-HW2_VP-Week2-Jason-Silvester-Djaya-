class Review {
  const Review({
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String author;

  /// Skala 0-5.
  final double rating;
  final String comment;
  final String date;
}