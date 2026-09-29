import '../models/drama.dart';

class DramaRepository {
  const DramaRepository();

  Future<List<Drama>> fetchDramas() async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    return _seed;
  }
}

const List<Drama> _seed = [
  Drama(
    id: '1',
    title: 'Love Between Fairy and Devil',
    origin: 'C-Drama · 2022',
    tags: ['Xianxia', 'Enemies-to-Lovers', 'Fantasy'],
    totalEpisodes: 36,
    watchedEpisodes: 12,
  ),
  Drama(
    id: '2',
    title: 'Business Proposal',
    origin: 'K-Drama · 2022',
    tags: ['CEO Male Lead', 'Rom-Com'],
    totalEpisodes: 12,
    watchedEpisodes: 12,
  ),
  Drama(
    id: '3',
    title: 'The Untamed',
    origin: 'C-Drama · 2019',
    tags: ['Wuxia', 'Fantasy', 'Bromance'],
    totalEpisodes: 50,
    watchedEpisodes: 3,
  ),
  Drama(
    id: '4',
    title: 'Crash Landing on You',
    origin: 'K-Drama · 2019',
    tags: ['Rom-Com', 'Enemies-to-Lovers'],
    totalEpisodes: 16,
  ),
  Drama(
    id: '5',
    title: 'Moon Embracing the Sun: Extended Director Cut Special Edition',
    origin: 'K-Drama · 2012',
    tags: ['Historical', 'Fantasy'],
    totalEpisodes: 20,
    watchedEpisodes: 7,
  ),
  Drama(
    id: '6',
    title: 'Eternal Love',
    origin: 'C-Drama · 2017',
    tags: ['Xianxia', 'Historical'],
    totalEpisodes: 58,
  ),
];