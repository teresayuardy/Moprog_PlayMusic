import 'package:flutter/material.dart';
import '../models/song.dart';

// Halaman detail lagu (artis, album, genre, durasi, rilis)
// iTunes API tidak menyediakan lirik dan credit
class DetailPage extends StatelessWidget {
  final Song song;
  const DetailPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Lagu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (song.artworkBesar != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(song.artworkBesar!, width: 250, height: 250,
                    errorBuilder: (_, _, _) => const Icon(Icons.music_note, size: 120)),
              ),
            ),
          const SizedBox(height: 16),
          Text(song.trackName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(song.artistName, style: const TextStyle(fontSize: 16)),
          const Divider(height: 32),
          Text('Album: ${song.albumName}'),
          Text('Genre: ${song.genre}'),
          Text('Durasi: ${song.durasi}'),
          Text('Rilis: ${song.rilis}'),
        ],
      ),
    );
  }
}