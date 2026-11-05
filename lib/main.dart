import 'package:flutter/material.dart';
import 'screens/favorite_page.dart';
import 'screens/playlist_page.dart';
import 'screens/search_page.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load(); // muat favorit, playlist, dan pilihan tema
  runApp(const MyApp());
}

// Membuat tema soft pink. [dark] = true untuk versi gelap (rose gelap)
ThemeData buildTheme({required bool dark}) {
  const pink = Color(0xFFF8BBD0);
  final bar = dark ? const Color(0xFF3B1F2B) : pink;
  final onBar = dark ? Colors.white : Colors.black;
  final base = dark ? ThemeData.dark() : ThemeData.light();

  return ThemeData(
    brightness: dark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: pink,
      brightness: dark ? Brightness.dark : Brightness.light,
      primary: pink,
      onPrimary: Colors.black,
    ),
    scaffoldBackgroundColor:
    dark ? const Color(0xFF1A1216) : const Color(0xFFFFF5F8),
    appBarTheme: AppBarTheme(backgroundColor: bar, foregroundColor: onBar),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: bar,
      indicatorColor: dark ? const Color(0xFF6D3348) : Colors.white70,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: pink,
      foregroundColor: Colors.black,
    ),
    textTheme: base.textTheme.apply(bodyColor: onBar, displayColor: onBar),
  );
}

// Root aplikasi: tema mengikuti pilihan terang / gelap di AppState
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplikasi Pemutar Lagu',
        theme: buildTheme(dark: false),
        darkTheme: buildTheme(dark: true),
        themeMode: appState.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeShell(),
      ),
    );
  }
}

// Kerangka dengan bottom navigation: Cari, Favorit, Playlist
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