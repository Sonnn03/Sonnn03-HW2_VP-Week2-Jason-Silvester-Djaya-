1. Which structural decision from Week 1 helped you most by Week 5?
    =Memisahkan kode menjadi models/, data/, dan presentation/, serta menaruh tema dan skala jarak di core/theme/.
    Saat menguji layout di Week 4 dan 5. Karena semua data lewat DramaRepository, saya cukup mengganti DramaScenario (normal, longText, empty, many) di main.dart untuk menguji judul 200 karakter, daftar kosong, dan 500 item tanpa menyentuh satu layar. Di Week 5, layar Statistik bisa ditambahkan hanya dengan file layar baru dan satu field episodeMinutes di Drama; repository dan tema tidak perlu diubah.
    Sehingga, main.dart hanya berisi satu konstanta _scenario untuk berganti kondisi uji. StatsScreen memakai AppSpacing dan colorScheme tanpa warna atau ukuran font hard-coded, dan mengganti seed colour cukup di app_theme.dart.

2. Which one cost you time, and what would you do differently?
    =Saat menguji di HP. Selama Week 1-4 saya hanya jalankan di Chrome, sehingga folder android/ tidak pernah disentuh atau ganti sama sekali.
    Saat menjalankan di HP, banyak muncul masalah sehingga agak membuang waktu

    AndroidManifest.xml tidak valid. Tag pembuka <manifest> tertimpa saat menambahkan izin internet, sehingga build gagal di processReleaseMainManifest.
    NDK 28.2.13676358 belum terpasang dan pemasangan otomatis Gradle gagal. Pemasangan manual lewat sdkmanager di PowerShell juga gagal pada percobaan pertama karena tanda ; pada ndk;28.2.13676358 memecah argumen.
    Build release pertama harus mengunduh komponen tambahan (CMake dan dependensi Gradle), sehingga lama.
    HP menolak pemasangan lewat USB (INSTALL_FAILED_USER_RESTRICTED) sampai opsi "Install via USB" di HP diizinkan.

3. Where is your app's state right now, and what will be hard about moving it in Module 2?
    = Posisi state sekarang. Seluruh state aplikasi hidup di setState milik _WatchlistScreenState: daftar drama (_dramas), status loading, kata kunci pencarian (_query), dan tag terpilih (_selectedTag). Layar lain tidak memiliki state sendiri untuk data ini, melainkan menerimanya lewat parameter konstruktor. DramaDetailScreen menerima drama, allDramas, dan callback onEpisodeWatched, sedangkan StatsScreen menerima salinan _dramas saat dibuka. State yang asli milik UI (misalnya _expanded pada ExpandableText) sudah benar berada di widget masing-masing dan tidak perlu dipindah.

    Yang akan sulit dipindahkan: 
    Sumber kebenaran ganda. DramaDetailScreen menyimpan salinan sendiri (_drama) dan baru memberi tahu layar daftar lewat callback. Data bisa berbeda antara dua layar, dan Module 2 harus menyatukannya menjadi satu sumber kebenaran.
    Data base. allDramas hanyalah snapshot saat layar dibuka. Jika progres diubah di layar detail lalu pengguna membuka drama yang sama lagi dari daftar "drama serupa", progres yang tampil bisa belum diperbarui. StatsScreen juga hanya menampilkan snapshot.
    Callback yang diteruskan antarlayar. onEpisodeWatched diteruskan dari daftar ke detail, lalu ke detail berikutnya. Setiap layar baru harus membawa callback yang sama, sehingga perubahan kecil memengaruhi banyak file.
    Tidak ada persistensi. fetchDramas() membuat data seed baru setiap dipanggil, sehingga progres menonton hilang saat "Muat ulang" atau saat aplikasi ditutup. Menyimpan progres berarti menentukan siapa yang memiliki data (repository atau state manager) dan kapan data disimpan.
    State async belum tertangani lengkap. Loading sudah ada, tetapi tidak ada state error. Saat data nyata (API atau database) dipakai, kegagalan harus punya tempat di model state.

    