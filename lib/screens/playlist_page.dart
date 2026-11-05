import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../widgets/playlist_sheet.dart';
import 'playlist_detail_page.dart';

// Tab Playlist: daftar playlist milik user, tekan lama untuk menghapus
class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  // Dialog konfirmasi sebelum playlist dihapus
  Future<void> konfirmasiHapus(BuildContext context, String nama) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus playlist?'),
        content: Text('Playlist "$nama" beserta isinya akan dihapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (yakin == true) appState.deletePlaylist(nama);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nama = await dialogBuatPlaylist(context);
          if (nama != null && !appState.createPlaylist(nama) && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nama kosong atau sudah dipakai')));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          if (appState.playlists.isEmpty) {
            return const Center(
                child: Text('Belum ada playlist.\nTekan + untuk membuat.',
                    textAlign: TextAlign.center));
          }
          return Column(
            children: [
              // Petunjuk gesture, hanya muncul kalau sudah ada playlist
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Ketuk sekali untuk membuka playlist • Tekan lama untuk menghapus playlist',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final e in appState.playlists.entries)
                      ListTile(
                        leading: const Icon(Icons.queue_music),
                        title: Text(e.key),
                        subtitle: Text('${e.value.length} lagu'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PlaylistDetailPage(name: e.key))),
                        onLongPress: () => konfirmasiHapus(context, e.key),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}