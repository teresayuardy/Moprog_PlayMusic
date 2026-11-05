import 'package:flutter/material.dart';
import '../models/song.dart';
import '../state/app_state.dart';

// Dialog input nama playlist baru, mengembalikan nama atau null jika dibatalkan
Future<String?> dialogBuatPlaylist(BuildContext context) {
  final c = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Playlist baru'),
      content: TextField(
        controller: c,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Nama playlist'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        TextButton(onPressed: () => Navigator.pop(context, c.text), child: const Text('Buat')),
      ],
    ),
  );
}

// Bottom sheet berisi daftar playlist untuk menambahkan [song]
void tampilkanPilihPlaylist(BuildContext context, Song song) {
  final messenger = ScaffoldMessenger.of(context);
  showModalBottomSheet(
    context: context,
    builder: (sheetContext) => ListenableBuilder(
      listenable: appState,
      builder: (_, __) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Buat playlist baru'),
            onTap: () async {
              final nama = await dialogBuatPlaylist(sheetContext);
              if (nama != null && appState.createPlaylist(nama)) {
                appState.addToPlaylist(nama.trim(), song);
                if (sheetContext.mounted) Navigator.pop(sheetContext);
                messenger.showSnackBar(
                    SnackBar(content: Text('Ditambahkan ke ${nama.trim()}')));
              }
            },
          ),
          for (final nama in appState.playlists.keys)
            ListTile(
              leading: const Icon(Icons.queue_music),
              title: Text(nama),
              onTap: () {
                final ok = appState.addToPlaylist(nama, song);
                Navigator.pop(sheetContext);
                messenger.showSnackBar(SnackBar(
                    content: Text(ok
                        ? 'Ditambahkan ke $nama'
                        : 'Lagu sudah ada di $nama')));
              },
            ),
        ],
      ),
    ),
  );
}