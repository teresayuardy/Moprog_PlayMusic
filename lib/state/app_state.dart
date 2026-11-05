import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song.dart';

// Menyimpan data yang dipakai banyak halaman: player, favorit, dan playlist
// ChangeNotifier memberi tahu UI (lewat ListenableBuilder) setiap ada perubahan
class AppState extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  Song? current; // lagu yang sedang dipilih
  bool isPlaying = false;
  List<Song> favorites = [];
  Map<String, List<Song>> playlists = {};

  AppState() {
    // Reset status saat preview selesai
    player.onPlayerComplete.listen((_) {
      isPlaying = false;
      current = null;
      notifyListeners();
    });
  }

  // Memuat favorit & playlist dari SharedPreferences saat app dibuka
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final fav = prefs.getString('favorites');
    final pl = prefs.getString('playlists');
    if (fav != null) {
      favorites = (jsonDecode(fav) as List).map((e) => Song.fromJson(e)).toList();
    }
    if (pl != null) {
      (jsonDecode(pl) as Map<String, dynamic>).forEach((name, list) {
        playlists[name] = (list as List).map((e) => Song.fromJson(e)).toList();
      });
    }
  }

  // Menyimpan favorit & playlist ke SharedPreferences
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'favorites', jsonEncode(favorites.map((s) => s.toJson()).toList()));
    await prefs.setString(
        'playlists',
        jsonEncode(playlists.map(
                (k, v) => MapEntry(k, v.map((s) => s.toJson()).toList()))));
  }

  bool isCurrent(Song s) => current?.id == s.id;

  // Play / pause
  // Mengembalikan false jika lagu tidak punya preview
  Future<bool> togglePlay(Song song) async {
    if (song.previewUrl == null) return false;
    if (isCurrent(song)) {
      isPlaying ? await player.pause() : await player.resume();
      isPlaying = !isPlaying;
    } else {
      await player.play(UrlSource(song.previewUrl!));
      current = song;
      isPlaying = true;
    }
    notifyListeners();
    return true;
  }

  bool isFavorite(Song s) => favorites.any((f) => f.id == s.id);

  void toggleFavorite(Song s) {
    isFavorite(s) ? favorites.removeWhere((f) => f.id == s.id) : favorites.add(s);
    _save();
    notifyListeners();
  }

  // Membuat playlist baru (false jika nama kosong / sudah ada)
  bool createPlaylist(String name) {
    name = name.trim();
    if (name.isEmpty || playlists.containsKey(name)) return false;
    playlists[name] = [];
    _save();
    notifyListeners();
    return true;
  }

  // Menambah lagu ke playlist (false jika lagu sudah ada di dalamnya)
  bool addToPlaylist(String name, Song s) {
    final list = playlists[name]!;
    if (list.any((e) => e.id == s.id)) return false;
    list.add(s);
    _save();
    notifyListeners();
    return true;
  }

  void deletePlaylist(String name) {
    playlists.remove(name);
    _save();
    notifyListeners();
  }
}

// Satu instance yang dipakai seluruh aplikasi
final appState = AppState();