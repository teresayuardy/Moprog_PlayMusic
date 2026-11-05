import 'package:flutter/material.dart';
import '../models/song.dart';
import '../screens/detail_page.dart';
import '../state/app_state.dart';
import 'playlist_sheet.dart';

// Satu baris lagu yang dipakai di semua halaman (tidak ada duplikasi).
// Gesture: tap = play/pause, double tap = favorit, long press = detail.
class SongTile extends StatelessWidget {
  final Song song;
  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final aktif = appState.isCurrent(song);
        return GestureDetector(
          onTap: () async {
            final ok = await appState.togglePlay(song);
            if (!ok && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preview tidak tersedia')));
            }
          },
          onDoubleTap: () => appState.toggleFavorite(song),
          onLongPress: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => DetailPage(song: song))),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: song.artworkUrl == null
                  ? const Icon(Icons.music_note, size: 48)
                  : Image.network(song.artworkUrl!, width: 48, height: 48,
                  errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 48)),
            ),
            title: Text(song.trackName, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(song.artistName, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (appState.isFavorite(song))
                  const Icon(Icons.favorite, color: Color(0xFFD81B60), size: 20),
                if (aktif)
                  Icon(appState.isPlaying ? Icons.pause : Icons.play_arrow),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => tampilkanPilihPlaylist(context, song),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}