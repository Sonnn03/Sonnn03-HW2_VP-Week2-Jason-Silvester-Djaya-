import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework2/core/theme/app_theme.dart';
import 'package:homework2/features/data/drama_repository.dart';
import 'package:homework2/features/models/drama.dart';
import 'package:homework2/features/models/review.dart';
import 'package:homework2/features/presentation/watchlist_screen.dart';
import 'package:homework2/features/presentation/widgets/drama_card.dart';
import 'package:homework2/features/presentation/widgets/drama_detail_screen.dart';
import 'package:homework2/features/presentation/widgets/drama_poster.dart';
import 'package:homework2/features/presentation/widgets/watchlist_empty_state.dart';

const Size small = Size(320, 568);
const Size large = Size(430, 932);
const Size tablet = Size(800, 1280);

const List<(String, Size)> screens = [
  ('small phone', small),
  ('large phone', large),
  ('tablet', tablet),
];

// ---------------------------------------------------------------------------
// Data uji (dibuat di sini, tidak perlu mengubah drama_repository.dart)
// ---------------------------------------------------------------------------

/// Repository palsu: langsung mengembalikan data yang diberikan, tanpa delay.
class FakeRepository extends DramaRepository {
  FakeRepository(this.dramas, {this.reviews = const []});

  final List<Drama> dramas;
  final List<Review> reviews;

  @override
  Future<List<Drama>> fetchDramas() async => dramas;

  @override
  Future<List<Review>> fetchReviews(String dramaId) async => reviews;
}

const _titles = [
  'Love Between Fairy and Devil',
  'Business Proposal',
  'The Untamed',
  'Crash Landing on You',
  'Moon Embracing the Sun: Extended Director Cut Special Edition',
  'Eternal Love',
];

const _tagPool = ['Fantasy', 'Romance', 'Historical'];

Drama makeDrama(
  int i, {
  String? title,
  String? origin,
  List<String>? tags,
  String? synopsis,
}) {
  return Drama(
    id: '$i',
    title: title ?? _titles[i % _titles.length],
    origin: origin ?? 'C-Drama · 2022',
    tags: tags ?? [_tagPool[i % 3], _tagPool[(i + 1) % 3]],
    totalEpisodes: 16,
    watchedEpisodes: (i * 3) % 13,
    posterUrl: 'https://picsum.photos/seed/drama-$i/400/600',
    rating: 4.5,
    synopsis: synopsis ?? 'Sinopsis singkat untuk drama nomor $i.',
  );
}

/// Data biasa: 6 drama.
List<Drama> get kMenu => List.generate(6, (i) => makeDrama(i + 1));

/// Test 5: nama 200 karakter — satu dengan spasi, satu tanpa spasi,
/// lengkap dengan origin, tag, dan sinopsis yang juga panjang.
List<Drama> get kLongNameMenu {
  final spaced = ('Judul sangat panjang sekali ' * 10).substring(0, 200);
  final unbroken = 'W' * 200;
  final longOrigin = 'K-Drama dengan asal yang juga sangat panjang · 2022 ' * 3;
  const longTag = 'Tag-yang-sangat-panjang-sekali-sampai-melebar-keluar-layar';
  final longSynopsis = 'Sinopsis yang sangat panjang sekali. ' * 40;
  return [
    for (final (i, title) in [spaced, unbroken].indexed)
      makeDrama(
        i + 1,
        title: title,
        origin: longOrigin,
        tags: [longTag, 'Fantasy'],
        synopsis: longSynopsis,
      ),
    makeDrama(3),
    makeDrama(4),
  ];
}

/// Test 7: 500 item.
List<Drama> get kBigMenu => List.generate(
      500,
      (i) => makeDrama(i + 1, title: '${_titles[i % _titles.length]} #${i + 1}'),
    );

const List<Review> kReviews = [
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
];

final List<Review> kLongReviews = [
  Review(
    author: 'Penulis review dengan nama yang sangat panjang ' * 4,
    rating: 4,
    comment: 'Komentar panjang sekali, ' * 30,
    date: '2 hari lalu',
  ),
];

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

/// Mengatur layar palsu, menampilkan layar, lalu menunggu semua animasi selesai.
Future<void> pumpLab(
  WidgetTester tester,
  Size size, {
  List<Drama>? dramas,
  Widget? home,
  double keyboard = 0,
  double topInset = 0,
  double bottomInset = 0,
  ThemeMode theme = ThemeMode.light,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  tester.view.padding = FakeViewPadding(top: topInset, bottom: bottomInset);
  tester.view.viewPadding = FakeViewPadding(top: topInset, bottom: bottomInset);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme,
      home: home ??
          WatchlistScreen(repository: FakeRepository(dramas ?? kMenu)),
    ),
  );
  await tester.pumpAndSettle();
}

/// Gagal dengan pesan asli Flutter, supaya terbaca widget, sumbu, dan pixelnya.
/// Kalau beberapa error terjadi sekaligus, pesannya hanya "Multiple exceptions"
/// — scroll ke atas di output test untuk membaca masing-masing.
void expectNoLayoutErrors(WidgetTester tester) {
  final Object? error = tester.takeException();
  expect(error, isNull, reason: 'Layout error:\n$error');
}

/// Scroll vertikal utama (bukan field pencarian, bukan chips tag).
Finder get mainScrollable => find
    .byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    )
    .first;

/// Layar detail untuk drama pertama pada [dramas].
Widget detailScreen(List<Drama> dramas, {List<Review> reviews = kReviews}) {
  return DramaDetailScreen(
    drama: dramas.first,
    allDramas: dramas,
    onEpisodeWatched: (_) {},
    repository: FakeRepository(dramas, reviews: reviews),
  );
}

void main() {
  group('Lab 04 — Watchlist screen', () {
    testWidgets('1 · small phone, 320 dp', (tester) async {
      await pumpLab(tester, small);
      expectNoLayoutErrors(tester);
      expect(find.byType(DramaCard), findsWidgets);
    });

    testWidgets('2 · large phone, 430 dp', (tester) async {
      await pumpLab(tester, large);
      expectNoLayoutErrors(tester);
      expect(find.byType(DramaCard), findsWidgets);
    });

    testWidgets('3 · tablet, 800 dp — the layout changes, it does not stretch',
        (tester) async {
      await pumpLab(tester, tablet);
      expectNoLayoutErrors(tester);
      expect(
        find.byType(SliverGrid),
        findsOneWidget,
        reason: 'At 800 dp the phone list should become a grid.',
      );
    });

    for (final (name, size) in screens) {
      testWidgets('4 · landscape — $name', (tester) async {
        await pumpLab(tester, size.flipped);
        expectNoLayoutErrors(tester);
        expect(find.byType(DramaCard), findsWidgets);
      });
    }

    for (final (name, size) in screens) {
      testWidgets('5 · a 200-character item name — $name', (tester) async {
        await pumpLab(tester, size, dramas: kLongNameMenu);
        expectNoLayoutErrors(tester);
        expect(
          find.textContaining('Judul sangat panjang'),
          findsWidgets,
          reason: 'The long-name data was not displayed.',
        );
      });
    }

    testWidgets('6 · zero items shows an empty state with icon, message, action',
        (tester) async {
      await pumpLab(tester, small, dramas: const <Drama>[]);
      expectNoLayoutErrors(tester);

      expect(find.byType(DramaCard), findsNothing);
      final empty = find.byType(WatchlistEmptyState);
      expect(empty, findsOneWidget, reason: 'Zero items needs an empty state.');
      expect(
        find.descendant(of: empty, matching: find.byType(Icon)),
        findsWidgets,
        reason: 'The empty state needs an icon.',
      );
      expect(
        find.descendant(of: empty, matching: find.byType(Text)),
        findsWidgets,
        reason: 'The empty state needs a message.',
      );
      expect(
        find.descendant(
          of: empty,
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
        findsWidgets,
        reason: 'The empty state needs an action (a button), '
            'also when no filter is active.',
      );
    });

    testWidgets('6 · zero items in landscape', (tester) async {
      await pumpLab(tester, small.flipped, dramas: const <Drama>[]);
      expectNoLayoutErrors(tester);
      expect(find.byType(WatchlistEmptyState), findsOneWidget);
    });

    testWidgets('7 · 500 items — built lazily, scrolled hard', (tester) async {
      await pumpLab(tester, small, dramas: kBigMenu);
      expectNoLayoutErrors(tester);
      expect(
        find.byType(DramaCard).evaluate().length,
        lessThan(100),
        reason:
            'Only the visible cards should be built. Is the list shrink-wrapped?',
      );

      for (var i = 0; i < 5; i++) {
        await tester.fling(mainScrollable, const Offset(0, -2000), 3000);
        await tester.pumpAndSettle();
      }
      expectNoLayoutErrors(tester);
    });

    testWidgets('8 · keyboard open on a short screen — content stays reachable',
        (tester) async {
      await pumpLab(tester, small, keyboard: 260);
      expectNoLayoutErrors(tester);

      final field = tester.getRect(find.byType(SearchBar));
      expect(
        field.bottom,
        lessThanOrEqualTo(small.height - 260),
        reason: 'The search field is hidden behind the keyboard.',
      );
      expect(
        tester.getRect(mainScrollable).bottom,
        lessThanOrEqualTo(small.height - 260),
        reason: 'The scrollable content should end above the keyboard '
            'so everything can be scrolled into view.',
      );

      await tester.enterText(find.byType(TextField), 'untamed');
      await tester.pumpAndSettle();
      expectNoLayoutErrors(tester);
      expect(find.byType(DramaCard), findsOneWidget);
    });

    testWidgets('8 · keyboard open in landscape', (tester) async {
      await pumpLab(tester, small.flipped, keyboard: 180);
      expectNoLayoutErrors(tester);

      final field = tester.getRect(find.byType(SearchBar));
      expect(
        field.top,
        lessThan(small.flipped.height - 180),
        reason: 'The search field starts below the keyboard line.',
      );

      await tester.enterText(find.byType(TextField), 'untamed');
      await tester.pumpAndSettle();
      expectNoLayoutErrors(tester);
    });

    for (final (name, size) in screens) {
      testWidgets('9 · dark mode — $name', (tester) async {
        await pumpLab(tester, size, theme: ThemeMode.dark);
        expectNoLayoutErrors(tester);
        final brightness =
            Theme.of(tester.element(find.byType(Scaffold).first)).brightness;
        expect(brightness, Brightness.dark);
        // Keterbacaan dicek dengan mata: jalankan app dan aktifkan dark mode.
      });
    }

    testWidgets('Bonus · notch and gesture bar', (tester) async {
      await pumpLab(tester, small, topInset: 32, bottomInset: 20);
      expectNoLayoutErrors(tester);

      final title = tester.getTopLeft(find.text('My Drama Watchlist'));
      expect(
        title.dy,
        greaterThanOrEqualTo(32),
        reason: 'The app bar title sits under the notch.',
      );

      for (var i = 0; i < 3; i++) {
        await tester.fling(mainScrollable, const Offset(0, -2000), 3000);
        await tester.pumpAndSettle();
      }
      final lastCard = tester.getRect(find.byType(DramaCard).last);
      expect(
        lastCard.bottom,
        lessThanOrEqualTo(small.height - 20),
        reason: 'The last card sits under the gesture bar. '
            'Which widget keeps content out of it?',
      );
    });
  });

  group('Lab 04 — Detail screen', () {
    for (final (name, size) in screens) {
      testWidgets('detail · portrait — $name', (tester) async {
        await pumpLab(tester, size, home: detailScreen(kMenu));
        expectNoLayoutErrors(tester);
        expect(find.text('Sinopsis'), findsOneWidget);
      });

      testWidgets('detail · landscape — $name', (tester) async {
        await pumpLab(tester, size.flipped, home: detailScreen(kMenu));
        expectNoLayoutErrors(tester);
        expect(find.text('Sinopsis'), findsOneWidget);
      });

      testWidgets('detail · long text — $name', (tester) async {
        await pumpLab(
          tester,
          size,
          home: detailScreen(kLongNameMenu, reviews: kLongReviews),
        );
        expectNoLayoutErrors(tester);
      });

      testWidgets('detail · long text landscape — $name', (tester) async {
        await pumpLab(
          tester,
          size.flipped,
          home: detailScreen(kLongNameMenu, reviews: kLongReviews),
        );
        expectNoLayoutErrors(tester);
      });

      testWidgets('detail · dark mode — $name', (tester) async {
        await pumpLab(
          tester,
          size,
          home: detailScreen(kMenu),
          theme: ThemeMode.dark,
        );
        expectNoLayoutErrors(tester);
      });
    }

    testWidgets('detail · tablet — the layout changes (poster beside the info)',
        (tester) async {
      await pumpLab(tester, tablet, home: detailScreen(kMenu));
      expectNoLayoutErrors(tester);

      final title = kMenu.first.title;
      final poster = tester.getRect(find.byType(DramaPoster).first);
      // Judul panel info (di dalam body), bukan judul yang ada di AppBar.
      final heading = tester.getRect(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.text(title),
        ),
      );
      expect(
        poster.right,
        lessThanOrEqualTo(heading.left),
        reason: 'At 800 dp the poster should sit beside the info, '
            'not stretch across the top.',
      );
    });
  });
}