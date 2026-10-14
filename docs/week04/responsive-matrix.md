## Breakpoint yang dipakai
 
| Layar | Lebar | Struktur layout |
|---|---|---|
| Watchlist | < 600 dp | List 1 kolom |
| Watchlist | 600–899 dp | Grid 2 kolom |
| Watchlist | ≥ 900 dp | Grid 3 kolom |
| Detail | < 720 dp | 1 kolom, header poster menyusut (`SliverAppBar`) |
| Detail | ≥ 720 dp | 2 panel: poster di kiri, info di kanan |

## Matrix: layar Watchlist
 
| # | Tes | Cara uji manual | Hasil yang diharapkan | Tes otomatis | Manual | Catatan |
|---|---|---|---|---|---|---|
| 1 | Small phone, 320 dp | Lebar 320 | Tidak ada overflow, list 1 kolom | ⬜ | ⬜ | |
| 2 | Large phone, 430 dp | Lebar 430 | Tidak ada overflow, list 1 kolom | ⬜ | ⬜ | |
| 3 | Tablet, 800 dp | Lebar 800 | Berubah menjadi grid 2 kolom | ⬜ | ⬜ | |
| 4 | Landscape (320/430/800) | Putar / tukar lebar-tinggi | Tidak ada overflow | ⬜ | ⬜ | |
| 5 | Nama 200 karakter (dengan spasi dan tanpa spasi) | `_scenario = DramaScenario.longText` di `main.dart` | Teks         terpotong dengan `…`, tidak overflow | ⬜ | ⬜ | |
| 6 | 0 item | `_scenario = DramaScenario.empty` | Empty state: ikon + pesan + tombol "Muat ulang" | ⬜ | ⬜ | |
| 7 | 500 item | `_scenario = DramaScenario.many` | Scroll lancar, dibangun lazy (tanpa `shrinkWrap`) | ⬜ | ⬜ | |
| 8 | Keyboard terbuka | Fokus ke field pencarian | Field dan konten tetap terjangkau | ⬜ | n/a* | |
| 9 | Dark mode | Ganti tema sistem ke gelap | Teks dan kartu terbaca | ⬜ | ⬜ | |

## Matrix: layar Detail
 
| # | Tes | Hasil yang diharapkan | Tes otomatis | Manual | Catatan |
|---|---|---|---|---|---|
| 1 | Portrait 320 / 430 / 800 | Tidak ada overflow, bagian "Sinopsis" tampil | ⬜ | ⬜ | |
| 4 | Landscape 320 / 430 / 800 | Header poster tidak memenuhi layar | ⬜ | ⬜ | |
| 3 | Tablet 800 dp | Poster di samping info | ⬜ | ⬜ | |
| 5 | Teks panjang (judul, origin, tag, sinopsis, review) | `maxLines` + ellipsis, sinopsis bisa "Selengkapnya" | ⬜ | ⬜ | |
| 9 | Dark mode | Teks di atas gradient poster tetap terbaca | ⬜ | ⬜ | |

## Perubahan yang dibuat untuk lolos matrix
 
| File | Perubahan |
|---|---|
| `drama_repository.dart` | `enum DramaScenario` + data skenario (normal, longText, empty, many) |
| `watchlist_screen.dart` | `CustomScrollView` + `LayoutBuilder` (list → grid 2 → grid 3), tap card membuka detail |
| `watchlist_empty_state.dart` | Aksi selalu ada ("Muat ulang" / "Reset pencarian") |
| `drama_card.dart` | `maxLines` + `overflow` pada teks origin dan tag |
| `episode_progress.dart` | `maxLines` + `overflow` pada label |
| `drama_detail_screen.dart` | Layout 2 panel ≥ 720 dp, tinggi header responsif, sinopsis expandable, tinggi "Drama serupa" ikut text scale |