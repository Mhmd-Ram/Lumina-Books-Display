/// Static configuration for the app's book data source.
///
/// The active source is Open Library (free, no API key, no quota). The Google
/// Books constants remain as an optional fallback — see [GoogleBooksService].
class ApiConfig {
  ApiConfig._();

  /// Active data source: Open Library.
  static const String openLibraryHost = 'openlibrary.org';
  static const String searchPath = '/search.json';

  /// Seed query so the home list isn't empty on first launch.
  static const String defaultQuery = 'bestseller';

  /// Results requested per search.
  static const int maxResults = 20;

  // ---- Optional Google Books fallback ----
  // Only used if GoogleBooksService is wired back in; pass a key with
  // `flutter run --dart-define=BOOKS_API_KEY=...` (never commit it).
  static const String host = 'www.googleapis.com';
  static const String volumesPath = '/books/v1/volumes';
  static const String apiKey = String.fromEnvironment('BOOKS_API_KEY');
}
