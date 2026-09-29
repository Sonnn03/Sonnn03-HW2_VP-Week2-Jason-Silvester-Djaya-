# Rationale Composition Widget (Week 02)

## Layar: WatchlistScreen

`WatchlistScreen` adalah satu-satunya pemilik state. Semua widget di bawah
adalah `StatelessWidget` yang menerima nilai dan melapor lewat callback.

### 1. `WatchlistSearchBar`
- **Pemicu:** Keterbacaan (membungkus konfigurasi `SearchBar`).
- **Memiliki:** Tidak ada. Controller dimiliki layar.
- **Melaporkan:** `onChanged(String)`.

### 2. `TagFilterChips`
- **Pemicu:** Keterbacaan (daftar chip horizontal dan logika pilihan).
- **Memiliki:** Tidak ada. Pilihan diterima lewat `selectedTag`.
- **Melaporkan:** `onSelected(String?)`. `null` berarti filter dihapus.

### 3. `DramaCard`
- **Pemicu:** Penggunaan ulang (satu kartu per item, bisa dipakai di layar lain).
- **Memiliki:** Tidak ada. Hanya menampilkan satu `Drama`.
- **Melaporkan:** `onEpisodeWatched()`.

### 4. `EpisodeProgress`
- **Pemicu:** Keterbacaan (memisahkan progress bar dari tata letak kartu).
- **Memiliki:** Tidak ada. Diturunkan dari `watched` dan `total`.
- **Melaporkan:** Tidak ada.

### 5. `WatchlistEmptyState`
- **Pemicu:** Keterbacaan (menangani daftar kosong dan pencarian tidak ditemukan).
- **Memiliki:** Tidak ada. Kasus dipilih lewat `hasFilters`.
- **Melaporkan:** `onClearFilters()`.

### 6. `WatchlistLoading`
- **Pemicu:** Keterbacaan (state loading punya nama sendiri).
- **Memiliki:** Tidak ada.
- **Melaporkan:** Tidak ada.

## State yang di-hoist
- `_query`, `_selectedTag`, dan `_dramas` berada di `WatchlistScreen` karena
  dibaca dan diubah oleh lebih dari satu widget.
- `TextEditingController` berada di layar agar tombol reset bisa mengosongkan
  kolom pencarian.