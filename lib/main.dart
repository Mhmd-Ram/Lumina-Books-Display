import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/config/api_config.dart';
import 'core/network/api_client.dart';
import 'core/settings/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/pages/auth_flow.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/catalog/data/books_repository.dart';
import 'features/catalog/data/open_library_service.dart';
import 'features/catalog/providers/books_provider.dart';
import 'features/catalog/providers/search_provider.dart';
import 'features/favorites/providers/favorites_provider.dart';
import 'features/home/pages/lumina_shell.dart';
import 'features/onboarding/pages/onboarding_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
            home: const _AppGate(),
          );
        },
      ),
    );
  }
}

/// Drives the launch flow: branded splash → onboarding (first launch) → login /
/// sign-up (until authenticated) → the main shell. The step is chosen from
/// [AuthProvider]; transitions cross-fade. In Phase 2, `authStateChanges` will
/// feed [AuthProvider] so a returning user auto-logs in straight to the shell.
class _AppGate extends StatefulWidget {
  const _AppGate();

  @override
  State<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<_AppGate> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final Widget screen;
    if (_showSplash) {
      screen = SplashScreen(onDone: () => setState(() => _showSplash = false));
    } else if (!auth.onboardingSeen) {
      screen = OnboardingScreen(onDone: auth.completeOnboarding);
    } else if (!auth.isAuthenticated) {
      screen = const AuthFlow();
    } else {
      screen = const LuminaShell();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: screen,
    );
  }
}
