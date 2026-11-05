import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/song_tile.dart';

// Tab Favorit: lagu yang ditambahkan ke favorit, bisa diputar dari sini
class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          if (appState.favorites.isEmpty) {
            return const Center(child: Text('Belum ada lagu favorit.\nKetuk dua kali pada lagu untuk menambahkan.', textAlign: TextAlign.center));
          }
          return ListView(
            children: appState.favorites.map((s) => SongTile(song: s)).toList(),
          );
        },
      ),
    );
  }
}