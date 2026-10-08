import '../models/drama.dart';
import '../models/review.dart';

class DramaRepository {
  const DramaRepository();

  Future<List<Drama>> fetchDramas() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return _seed;
  }

  Future<List<Review>> fetchReviews(String dramaId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
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
    rating: 4.8,
    synopsis:
        'Dua kultivator dengan sifat bertolak belakang bekerja sama '
        'mengungkap konspirasi besar yang mengancam dunia persilatan, '
        'sambil menjaga persahabatan yang diuji waktu.',
  ),
  Drama(
    id: '4',
    title: 'Crash Landing on You',
    origin: 'K-Drama · 2019',
    tags: ['Rom-Com', 'Enemies-to-Lovers'],
    totalEpisodes: 16,
    posterUrl: _poster('drama-4'),
    rating: 4.9,
    synopsis:
        'Pewaris perusahaan asal Korea Selatan mendarat darurat di Korea '
        'Utara dengan paralayang dan bertemu seorang perwira yang '
        'melindunginya diam-diam.',
  ),
  Drama(
    id: '5',
    title: 'Moon Embracing the Sun: Extended Director Cut Special Edition',
    origin: 'K-Drama · 2012',
    tags: ['Historical', 'Fantasy'],
    totalEpisodes: 20,
    watchedEpisodes: 7,
    posterUrl: _poster('drama-5'),
    rating: 4.4,
    synopsis:
        'Kisah cinta seorang raja dan gadis shaman yang kehilangan ingatan, '
        'dibalut intrik istana dan kutukan yang memisahkan mereka.',
  ),
  Drama(
    id: '6',
    title: 'Eternal Love',
    origin: 'C-Drama · 2017',
    tags: ['Xianxia', 'Historical'],
    totalEpisodes: 58,
    posterUrl: _poster('drama-6'),
    rating: 4.7,
    synopsis:
        'Dewi yang menyamar sebagai pria dan Dewa Perang yang dingin '
        'terikat cinta lintas tiga kehidupan, dari dunia langit hingga '
        'dunia fana.',
  ),
];

const List<Review> _reviewPool = [
  Review(
    author: 'Dinda',
    rating: 5,
    comment: 'Ceritanya bikin nagih, chemistry pemeran utamanya juara!',
    date: '2 hari lalu',
  ),
  Review(
    author: 'Raka',
    rating: 4,
    comment: 'Visual dan OST-nya bagus. Pertengahan agak lambat tapi worth it.',
    date: '1 minggu lalu',
  ),
  Review(
    author: 'Salsa',
    rating: 4.5,
    comment: 'Sudah nonton ulang dua kali dan tetap seru.',
    date: '2 minggu lalu',
  ),
  Review(
    author: 'Bima',
    rating: 3.5,
    comment: 'Bagus, tapi endingnya terasa agak terburu-buru.',
    date: '3 minggu lalu',
  ),
  Review(
    author: 'Citra',
    rating: 5,
    comment: 'Salah satu drama terbaik yang pernah saya tonton. Wajib masuk list!',
    date: '1 bulan lalu',
  ),
];