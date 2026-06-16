import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/config/api_config.dart';
import 'core/network/api_client.dart';
import 'core/settings/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/catalog/data/books_repository.dart';
import 'features/catalog/data/open_library_service.dart';
import 'features/catalog/providers/books_provider.dart';
import 'features/catalog/providers/search_provider.dart';
import 'features/favorites/providers/favorites_provider.dart';
import 'features/home/pages/lumina_shell.dart';
import 'features/splash/pages/splash_screen.dart';

void main() {
  runApp(const LuminaApp());
}

/// Lumina — a book-discovery app over the Open Library API. State is held in
/// Provider; the UI is themed light/dark with English/Arabic (RTL) support.
class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // One shared repository for both the catalog and search providers.
        Provider<BooksRepository>(
          create: (_) => BooksRepository(OpenLibraryService(ApiClient())),
        ),
        // Home catalog (seeded so the home isn't empty on first launch).
        ChangeNotifierProvider<BooksProvider>(
          create: (context) => BooksProvider(context.read<BooksRepository>())
            ..search(ApiConfig.defaultQuery),
        ),
        // Search tab (loads its seed results lazily when first opened).
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(context.read<BooksRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Lumina',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.build(
              brightness: Brightness.light,
              locale: settings.locale,
            ),
            darkTheme: AppTheme.build(
              brightness: Brightness.dark,
              locale: settings.locale,
            ),
            themeMode: settings.themeMode,
            locale: settings.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const _SplashGate(),
          );
        },
      ),
    );
  }
}

/// Shows the branded splash on launch, then fades into the main shell.
class _SplashGate extends StatefulWidget {
  const _SplashGate();

  @override
  State<_SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<_SplashGate> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _showSplash
          ? SplashScreen(onDone: () => setState(() => _showSplash = false))
          : const LuminaShell(),
    );
  }
}
