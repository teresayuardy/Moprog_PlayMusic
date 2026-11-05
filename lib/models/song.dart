// Model data lagu hasil parsing JSON dari iTunes Search API
class Song {
  final int id;
  final String trackName;
  final String artistName;
  final String albumName;
  final String genre;
  final String? artworkUrl;
  final String? previewUrl;
  final String? releaseDate;
  final int? durationMillis;

  Song({
    required this.id,
    required this.trackName,
    required this.artistName,
    required this.albumName,
    required this.genre,
    this.artworkUrl,
    this.previewUrl,
    this.releaseDate,
    this.durationMillis,
  });

  // Dipakai untuk data dari API maupun data yang tersimpan di SharedPreferences
  factory Song.fromJson(Map<String, dynamic> json) => Song(
    id: json['trackId'] ?? 0,
    trackName: json['trackName'] ?? 'Tanpa judul',
    artistName: json['artistName'] ?? 'Tanpa artis',
    albumName: json['collectionName'] ?? '-',
    genre: json['primaryGenreName'] ?? '-',
    artworkUrl: json['artworkUrl100'],
    previewUrl: json['previewUrl'],
    releaseDate: json['releaseDate'],
    durationMillis: json['trackTimeMillis'],
  );

  // Mengembalikan format JSON yang sama dengan API, supaya fromJson bisa dipakai ulang
  Map<String, dynamic> toJson() => {
    'trackId': id,
    'trackName': trackName,
    'artistName': artistName,
    'collectionName': albumName,
    'primaryGenreName': genre,
    'artworkUrl100': artworkUrl,
    'previewUrl': previewUrl,
    'releaseDate': releaseDate,
    'trackTimeMillis': durationMillis,
  };

  // Durasi dalam format m:ss
  String get durasi {
    if (durationMillis == null) return '-';
    final detik = durationMillis! ~/ 1000;
    return '${detik ~/ 60}:${(detik % 60).toString().padLeft(2, '0')}';
  }

  // Tanggal rilis (yyyy-mm-dd)
  String get rilis => releaseDate != null ? releaseDate!.substring(0, 10) : '-';

  // Cover resolusi lebih tinggi untuk halaman detail
  String? get artworkBesar => artworkUrl?.replaceAll('100x100', '600x600');
}