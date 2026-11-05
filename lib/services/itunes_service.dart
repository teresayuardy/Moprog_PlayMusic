import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

// Service untuk request ke iTunes Search API
class ItunesService {
  // Mencari lagu, melempar exception jika gagal
  static Future<List<Song>> cariLagu(String query) async {
    final url = Uri.https('itunes.apple.com', '/search', {
      'term': query,
      'limit': '20',
      'entity': 'song',
    });

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      // Validasi status code
      if (response.statusCode != 200) {
        throw Exception('Server bermasalah (kode ${response.statusCode})');
      }

      final data = jsonDecode(response.body);
      final results = data['results'] as List;
      return results.map((e) => Song.fromJson(e)).toList();
    } on Exception catch (e) {
      // Pesan error untuk masalah koneksi / timeout / parsing
      if (e.toString().contains('Server bermasalah')) rethrow;
      throw Exception('Gagal terhubung. Periksa koneksi internetmu.');
    }
  }
}