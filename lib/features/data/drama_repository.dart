import '../models/drama.dart';
import '../models/review.dart';

/// Skenario data untuk menguji layout responsif.
enum DramaScenario { normal, longText, empty, many }

class DramaRepository {
  const DramaRepository({this.scenario = DramaScenario.normal});

  final DramaScenario scenario;

  List<Review> get _reviewPool => [
    Review(
      author: 'Alya',
      rating: 5,
      comment: 'Cerita yang menarik dan sangat menghibur.',
      date: '1 hari lalu',
    ),
    Review(
      author: 'Bima',
      rating: 4,
      comment: 'Alur ceritanya bagus dan para pemainnya hebat.',
      date: '3 hari lalu',
    ),
    Review(
      author: 'Citra',
      rating: 5,
      comment: 'Salah satu drama favorit saya.',
      date: '1 minggu lalu',
    ),
  ];

  Future<List<Drama>> fetchDramas() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    switch (scenario) {
      case DramaScenario.normal:
        return _seed;
      case DramaScenario.empty:
        return const <Drama>[];
      case DramaScenario.longText:
        return _longTextDramas();
      case DramaScenario.many:
        return _manyDramas();
    }
  }

  Future<List<Review>> fetchReviews(String dramaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (scenario == DramaScenario.longText) {
      return [
        Review(
          author: 'Penulis review dengan nama yang sangat panjang ' * 4,
          rating: 4,
          comment: 'Komentar panjang sekali, ' * 20,
          date: '2 hari lalu',
        ),
      ];
    }
    final start = (int.tryParse(dramaId) ?? 0) % _reviewPool.length;
    return [
      for (var i = 0; i < 3; i++) _reviewPool[(start + i) % _reviewPool.length],
    ];
  }

  /// Drama serupa = drama lain yang paling banyak berbagi tag.
  List<Drama> similarTo(Drama drama, List<Drama> all) {
    final scored = <(Drama, int)>[];
    for (final other in all) {
      if (other.id == drama.id) continue;
      final shared = other.tags.where(drama.tags.contains).length;
      if (shared > 0) scored.add((other, shared));
    }
    scored.sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final entry in scored.take(5)) entry.$1];
  }
}

String _poster(String seed) => 'https://picsum.photos/seed/$seed/400/600';

/// Test "Long text": judul 200 karakter (satu dengan spasi, satu tanpa spasi).
List<Drama> _longTextDramas() {
  final spaced = ('Judul sangat panjang sekali ' * 10).substring(0, 200);
  final unbroken = 'W' * 200;
  return [
    for (final (i, title) in [spaced, unbroken].indexed)
      Drama(
        id: '${i + 1}',
        title: title,
        origin: 'K-Drama dengan asal yang juga sangat panjang · 2022 ' * 3,
        tags: [
          'Tag-yang-sangat-panjang-sekali-sampai-melebar-keluar-layar',
          'Fantasy',
          'Romance',
        ],
        totalEpisodes: 36,
        watchedEpisodes: 12,
        posterUrl: _poster('long-$i'),
        rating: 4.5,
        synopsis: 'Sinopsis yang sangat panjang sekali. ' * 30,
      ),
    ..._seed.take(2),
  ];
}

/// Test "Long list": 500 item.
List<Drama> _manyDramas() {
  return List.generate(500, (i) {
    final base = _seed[i % _seed.length];
    return Drama(
      id: '${i + 1}',
      title: '${base.title} #${i + 1}',
      origin: base.origin,
      tags: base.tags,
      totalEpisodes: base.totalEpisodes,
      watchedEpisodes: base.watchedEpisodes,
      posterUrl: _poster('drama-${i + 1}'),
      rating: base.rating,
      synopsis: base.synopsis,
    );
  });
}

final List<Drama> _seed = [
  Drama(
    id: '1',
    title: 'Love Between Fairy and Devil',
    origin: 'C-Drama · 2022',
    tags: ['Xianxia', 'Enemies-to-Lovers', 'Fantasy'],
    totalEpisodes: 36,
    watchedEpisodes: 12,
    posterUrl: _poster('drama-1'),
    rating: 4.6,
    synopsis:
        'Seorang putri peri dari klan Cang Lan dan pangeran iblis dari klan '
        'Yao saling bermusuhan, namun terikat oleh takdir dan perasaan yang '
        'tumbuh di tengah perebutan kekuasaan antara dua dunia.',
  ),
  Drama(
    id: '2',
    title: 'Business Proposal',
    origin: 'K-Drama · 2022',
    tags: ['CEO Male Lead', 'Rom-Com'],
    totalEpisodes: 12,
    watchedEpisodes: 12,
    posterUrl: _poster('drama-2'),
    rating: 4.5,
    synopsis:
        'Seorang karyawati menyamar sebagai sahabatnya untuk kencan buta, '
        'tapi lawan kencannya ternyata CEO perusahaannya sendiri. '
        'Kesalahpahaman lucu pun dimulai.',
  ),
  Drama(
    id: '3',
    title: 'The Untamed',
    origin: 'C-Drama · 2019',
    tags: ['Wuxia', 'Fantasy', 'Bromance'],
    totalEpisodes: 50,
    watchedEpisodes: 3,
    posterUrl: _poster('drama-3'),
    rating: 4.7,
    synopsis:
        'Dua pria dari latar belakang yang berbeda, yang saling bermusuhan '
        'namun terikat oleh takdir, berjuang untuk memperjuangkan keadilan '
        'dan kebenaran di dunia yang penuh dengan kekerasan dan ketidakadilan.',
  ),
];