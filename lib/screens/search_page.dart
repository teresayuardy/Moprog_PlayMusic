import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/itunes_service.dart';
import '../widgets/song_tile.dart';

// Tab Cari: pencarian lagu dengan loading, error, hasil kosong, dan pull-to-refresh
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  List<Song> songs = [];
  bool loading = false;
  String? error;
  String lastQuery = '';

  Future<void> cari([String? query]) async {
    final q = (query ?? controller.text).trim();
    if (q.isEmpty) return; // query kosong tidak dikirim
    lastQuery = q;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final hasil = await ItunesService.cariLagu(q);
      setState(() => songs = hasil);
    } catch (e) {
      setState(() {
        songs = [];
        error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _pesan(String teks) => Padding(
    padding: const EdgeInsets.all(32),
    child: Center(child: Text(teks, textAlign: TextAlign.center)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Lagu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => cari(), // tombol Enter memicu pencarian
              decoration: InputDecoration(
                labelText: 'Judul lagu atau artis',
                suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: cari),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
            if (songs.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Ketuk sekali untuk play/pause • Ketuk dua kali untuk favorit • Tekan lama untuk melihat detail lagu',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: () => lastQuery.isEmpty ? Future.value() : cari(lastQuery),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (error != null) _pesan(error!)
                    else if (lastQuery.isEmpty) _pesan('Cari lagu favoritmu di sini 🎵')
                    else if (songs.isEmpty) _pesan('Lagu tidak ditemukan')
                      else ...songs.map((s) => SongTile(song: s)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}