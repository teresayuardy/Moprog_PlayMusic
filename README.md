# 🎵 Mobile Programming - Aplikasi Pemutar Lagu

Aplikasi pemutar lagu sederhana berbasis Flutter yang mengambil data dari **iTunes Search API**. Pengguna bisa mencari lagu berdasarkan judul atau artis, memutar preview lagu, melihat detail lagu, menyimpan lagu favorit, dan membuat playlist sendiri.

> Tugas Mata Kuliah Mobile Programming  
> **Nama:** _Teresa Yuardy_ | **NIM:** _825240031_

## Fitur

- **Pencarian lagu** berdasarkan judul atau artis (tombol Enter juga memicu pencarian).
- **Pemutaran preview** lagu (30 detik, sesuai batasan iTunes API) dengan tombol play/pause.
- **Detail lagu**: cover, judul, artis, album, genre, durasi, dan tanggal rilis.
- **Favorit**: simpan lagu favorit, bisa diputar langsung dari tab Favorit.
- **Playlist**: buat banyak playlist, tambahkan lagu lewat tombol **+**, hapus playlist dengan konfirmasi.
- **Penyimpanan lokal**: favorit dan playlist tetap ada setelah aplikasi ditutup (`shared_preferences`).
- **Loading, error state, dan hasil kosong**, serta **pull-to-refresh** pada hasil pencarian.
- **Tema soft pink** dengan teks hitam, plus **dark mode** (tombol bulan/matahari di tab Cari, pilihannya tersimpan).

## Gesture

| Gesture | Fungsi |
|---|---|
| Ketuk sekali | Play / pause preview lagu |
| Ketuk dua kali | Tambah / hapus dari favorit |
| Tekan lama | Buka halaman detail lagu |
| Tombol **+** | Tambahkan lagu ke playlist |
| Tekan lama (di daftar playlist) | Hapus playlist (dengan konfirmasi) |

## Struktur Project

```
lib/
├── main.dart                     # Tema dan bottom navigation (Cari, Favorit, Playlist)
├── models/
│   └── song.dart                 # Model Song (fromJson / toJson)
├── services/
│   └── itunes_service.dart       # Request ke iTunes API + validasi status code
├── state/
│   └── app_state.dart            # Player, favorit, playlist, dan penyimpanan lokal
├── screens/
│   ├── search_page.dart          # Tab Cari
│   ├── favorite_page.dart        # Tab Favorit
│   ├── playlist_page.dart        # Tab Playlist
│   ├── playlist_detail_page.dart # Isi satu playlist
│   └── detail_page.dart          # Detail lagu
└── widgets/
    ├── song_tile.dart            # Baris lagu (dipakai di semua halaman)
    └── playlist_sheet.dart       # Bottom sheet & dialog playlist
```

## Package yang Digunakan

| Package | Kegunaan |
|---|---|
| `http` | Mengambil data dari iTunes Search API |
| `audioplayers` | Memutar preview lagu |
| `shared_preferences` | Menyimpan favorit dan playlist secara lokal |

## Cara Menjalankan

1. Pastikan Flutter sudah terpasang (`flutter doctor`).
2. Clone repository:
   ```bash
   git clone https://github.com/teresayuardy/Moprog_PlayMusic.git
   cd Moprog_PlayMusic
   ```
3. Install dependency:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```
   Untuk web (port dibuat tetap supaya data lokal tidak hilang):
   ```bash
   flutter run -d edge --web-port=5000
   ```

## Alur Data

1. Pengguna mengetik kata kunci di tab **Cari**.
2. `ItunesService` mengirim request ke `https://itunes.apple.com/search`, memeriksa status code, lalu mengubah JSON menjadi daftar objek `Song`.
3. Hasilnya ditampilkan lewat `SongTile`. Jika gagal, tampil pesan error; jika kosong, tampil "Lagu tidak ditemukan".
4. `AppState` (`ChangeNotifier`) mengelola lagu yang sedang diputar, favorit, dan playlist, lalu menyimpannya ke `shared_preferences`.

## Keterbatasan

- iTunes API hanya menyediakan **preview 30 detik**, bukan lagu penuh.
- iTunes API **tidak menyediakan lirik dan credit** lagu, sehingga halaman detail menampilkan data yang tersedia saja.
- Beberapa lagu tidak memiliki preview; aplikasi menampilkan pesan "Preview tidak tersedia".
- Memutar lagu otomatis berurutan (next/previous) belum tersedia.
