import 'package:flutter/material.dart';
import 'screens/favorite_page.dart';
import 'screens/playlist_page.dart';
import 'screens/search_page.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load(); // muat favorit & playlist tersimpan
  runApp(const MyApp());
}

// Root aplikasi: tema soft pink dengan teks hitam.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFF8BBD0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Pemutar Lagu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: pink, primary: pink, onPrimary: Colors.black),
        scaffoldBackgroundColor: const Color(0xFFFFF5F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: pink,
          foregroundColor: Colors.black,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: pink,
          indicatorColor: Colors.white70,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: pink,
          foregroundColor: Colors.black,
        ),
        textTheme: ThemeData.light().textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
      ),
      home: const HomeShell(),
    );
  }
}

// Kerangka dengan bottom navigation: Cari, Favorit, Playlist.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga hasil pencarian tetap ada saat pindah tab
      body: IndexedStack(
        index: index,
        children: const [SearchPage(), FavoritePage(), PlaylistPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorit'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Playlist'),
        ],
      ),
    );
  }
}