import 'package:booksapi/core/theme/app_theme.dart';
import 'package:booksapi/features/catalog/models/book.dart';
import 'package:booksapi/features/details/pages/book_details_sheet.dart';
import 'package:booksapi/features/favorites/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  setUpAll(() {
    // Don't hit the network for fonts during tests.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const book = Book(
    id: 't1',
    title: 'Test Title',
    authors: ['Jane Doe'],
    publisher: 'Pub House',
    publishedDate: '2020',
    pageCount: 123,
    language: 'eng',
    categories: ['Fantasy', 'Magic'],
    averageRating: 4.2,
    ratingsCount: 99,
    isbns: ['9781234567890'],
    infoLink: 'https://openlibrary.org/works/t1',
  );

  Widget harness() {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavoritesProvider())],
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.build(brightness: Brightness.light, locale: const Locale('en')),
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => openBookDetails(context, book),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('opens, reveals content, then closes', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.text('open'));
    await tester.pump(); // push the route
    // Initial hold (180ms) + flap open (900ms), with margin.
    await tester.pump(const Duration(milliseconds: 1300));

    // The revealed details content must be present (regression: the Stack used
    // to collapse to 0×0 once the flap unmounted, hiding everything).
    expect(find.text('Get the Book'), findsOneWidget);
    expect(find.text('Test Title'), findsWidgets);
    expect(find.text('by Jane Doe'), findsOneWidget);
    expect(tester.getSize(find.byType(ListView)).height, greaterThan(0));

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pump();
    // Flap shut (900ms) + closing hold (180ms) before pop, with margin.
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Get the Book'), findsNothing);
  });
}
