## Overflow 1
Penjelasan: Row memberi child yang tidak fleksibel constraint lebar tak terbatas pada sumbu utamanya. Column lalu menyesuaikan lebarnya dengan anak terlebar, yaitu teks judul. Karena lebar tak terbatas, teks atur dalam satu baris panjang. maxLines: 2 tidak membantu, karena teks tidak pernah menemui batas lebar untuk dipecah. Total lebar child Row melebihi lebar layar, sehingga muncul overflow di sisi kanan.

Perbaikan: membungkus Column dengan Expanded. Expanded mengubah constraint lebar menjadi terbatas, sehingga teks membungkus dan terpotong oleh maxLines + overflow.

## Overflow 2
Penjelasan: SizedBox(height: 80) memberi Column tinggi ketat 80 dp. Column meneruskan tinggi tak terbatas ke Child non-fleksibelnya, sehingga Text sinopsis bebas atur sebanyak baris yang dibutuhkan (tanpa maxLines, tujuh baris atau lebih pada layar sempit). Tinggi teks ditambah tombol "Selengkapnya" jauh melebihi 80 dp, tetapi Column tidak bisa scroll, sehingga isinya keluar di bagian bawah.

Perbaikan: memakai _ExpandableText. Sinopsis dibatasi maxLines: 4 dengan overflow: ellipsis, sehingga tingginya selalu terbatas. Tombol "Selengkapnya" membuka teks penuh ke dalam layar yang bisa di-scroll, tanpa kotak setinggi tetap.

## Overflow 3
Penjelasan: mainAxisExtent memaksa setiap sel grid memiliki tinggi tepat 100 dp. Ini constraint ketat: tinggi minimum dan maksimum sama. DramaCard mengurangi 32 dp untuk padding, sehingga Row hanya mendapat sekitar 68 dp. Isi Column teks (judul dua baris, origin, tag, dan progress). Child tidak bisa meminta ruang lebih dari constraint ketat, sehingga Column keluar di bagian bawah.

Perbaikan: mengembalikan tinggi sel ke nilai yang cukup untuk isi kartu dan ikut skala teks.