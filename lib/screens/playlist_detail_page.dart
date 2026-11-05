import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/song_tile.dart';

// Isi satu playlist, lagunya bisa diputar
class PlaylistDetailPage extends StatelessWidget {
  final String name;
  const PlaylistDetailPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final lagu = appState.playlists[name] ?? [];
          if (lagu.isEmpty) return const Center(child: Text('Playlist masih kosong'));
          return ListView(children: lagu.map((s) => SongTile(song: s)).toList());
        },
      ),
    );
  }
}