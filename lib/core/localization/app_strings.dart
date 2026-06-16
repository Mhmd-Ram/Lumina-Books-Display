import 'package:flutter/widgets.dart';

/// All localized chrome strings for the two supported languages (English and
/// Arabic), mirroring the prototype's `T` object. Book titles and authors stay
/// in their original language — only the surrounding UI is translated.
///
/// Read it with `AppStrings.of(context)` (or the `context.s` helper), which
/// picks the set from the active [Locale].
@immutable
class AppStrings {
  final String appName;
  final String tagline;
  final String hello;
  final String morning;
  final String afternoon;
  final String evening;
  final String featured;
  final String trending;
  final String arrivals;
  final String seeAll;
  final String discover;
  final String findNext;
  final String searchPlaceholder;
  final String results;
  final String noBooks;
  final String noBooksSub;
  final String library;
  final String favorites;
  final String noFavs;
  final String noFavsSub;
  final String navHome;
  final String navSearch;
  final String navFav;
  final String bookDetails;
  final String by;
  final String publisher;
  final String published;
  final String pages;
  final String language;
  final String categories;
  final String isbns;
  final String getBook;

  const AppStrings({
    required this.appName,
    required this.tagline,
    required this.hello,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.featured,
    required this.trending,
    required this.arrivals,
    required this.seeAll,
    required this.discover,
    required this.findNext,
    required this.searchPlaceholder,
    required this.results,
    required this.noBooks,
    required this.noBooksSub,
    required this.library,
    required this.favorites,
    required this.noFavs,
    required this.noFavsSub,
    required this.navHome,
    required this.navSearch,
    required this.navFav,
    required this.bookDetails,
    required this.by,
    required this.publisher,
    required this.published,
    required this.pages,
    required this.language,
    required this.categories,
    required this.isbns,
    required this.getBook,
  });

  bool get isArabic => this == ar;

  /// Time-of-day greeting eyebrow, by local [hour] (0–23).
  String greeting(int hour) =>
      hour < 12 ? morning : (hour < 18 ? afternoon : evening);

  /// A reader-friendly category label: API subjects are often hyphenated or long
  /// phrases ("Man-woman relationships", "self-help", "Juvenile fiction"), so we
  /// tidy them into a clean 1–2 word label, then localize known names to Arabic.
  String category(String raw) {
    final pretty = prettyCategory(raw);
    return isArabic ? (_ar[pretty] ?? pretty) : pretty;
  }

  /// Cleans a raw category into at most two title-cased words.
  static String prettyCategory(String raw) {
    final override = _categoryOverrides[raw.trim().toLowerCase()];
    if (override != null) return override;

    final cleaned = raw
        .replaceAll(RegExp(r'[-–—_/\\:,.;]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return raw.trim();

    const drop = {
      'and', 'or', 'the', 'of', 'in', 'a', 'an', 'to', 'with', 'for',
      'general', 'etc', '&',
    };
    final words = cleaned.split(' ');
    final kept = words.where((w) => !drop.contains(w.toLowerCase())).toList();
    final chosen = (kept.isEmpty ? words : kept).take(2).map(_capitalize);
    return chosen.join(' ');
  }

  static String _capitalize(String w) => w.isEmpty
      ? w
      : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';

  /// Hand-tuned labels for common awkward subjects the heuristic can't infer.
  static const Map<String, String> _categoryOverrides = {
    'man-woman relationships': 'Relationships',
    'self-help': 'Self Help',
    'non-fiction': 'Nonfiction',
    'science fiction': 'Sci-Fi',
    'juvenile fiction': 'Juvenile',
    'juvenile nonfiction': 'Juvenile',
    'young adult fiction': 'Young Adult',
    'large type books': 'Large Print',
    'new york times bestseller': 'Bestseller',
    'coming of age': 'Growing Up',
    'bildungsromans': 'Growing Up',
  };

  static const AppStrings en = AppStrings(
    appName: 'Lumina',
    tagline: 'Discover your next story',
    hello: 'Hello, Reader',
    morning: 'Good morning',
    afternoon: 'Good afternoon',
    evening: 'Good evening',
    featured: 'Featured',
    trending: 'Trending now',
    arrivals: 'New arrivals',
    seeAll: 'See all',
    discover: 'Discover',
    findNext: 'Find your next book',
    searchPlaceholder: 'Search books, authors, or ISBNs…',
    results: 'results',
    noBooks: 'No books found',
    noBooksSub: 'Try a different title or author.',
    library: 'Your library',
    favorites: 'Favorites',
    noFavs: 'No favorites yet',
    noFavsSub: 'Tap the heart on any book to save it here.',
    navHome: 'Home',
    navSearch: 'Search',
    navFav: 'Favorites',
    bookDetails: 'Book details',
    by: 'by',
    publisher: 'Publisher',
    published: 'Published',
    pages: 'Pages',
    language: 'Language',
    categories: 'Categories',
    isbns: 'ISBNs',
    getBook: 'Get the Book',
  );

  static const AppStrings ar = AppStrings(
    appName: 'لومينا',
    tagline: 'اكتشف قصتك القادمة',
    hello: 'مرحباً أيها القارئ',
    morning: 'صباح الخير',
    afternoon: 'مساء الخير',
    evening: 'مساء الخير',
    featured: 'مختارات',
    trending: 'الأكثر رواجاً',
    arrivals: 'وصل حديثاً',
    seeAll: 'عرض الكل',
    discover: 'استكشف',
    findNext: 'ابحث عن كتابك التالي',
    searchPlaceholder: 'ابحث عن كتب أو مؤلفين أو ISBN...',
    results: 'نتيجة',
    noBooks: 'لا توجد كتب',
    noBooksSub: 'جرّب عنواناً أو مؤلفاً آخر.',
    library: 'مكتبتك',
    favorites: 'المفضلة',
    noFavs: 'لا مفضلات بعد',
    noFavsSub: 'اضغط القلب على أي كتاب لإضافته هنا.',
    navHome: 'الرئيسية',
    navSearch: 'بحث',
    navFav: 'المفضلة',
    bookDetails: 'تفاصيل الكتاب',
    by: 'بقلم',
    publisher: 'الناشر',
    published: 'سنة النشر',
    pages: 'الصفحات',
    language: 'اللغة',
    categories: 'التصنيفات',
    isbns: 'الأرقام المعيارية',
    getBook: 'احصل على الكتاب',
  );

  static AppStrings of(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' ? ar : en;

  /// English → Arabic category names (from the prototype's `CAT` map).
  static const Map<String, String> _ar = {
    'Fantasy': 'خيال',
    'Young Adult': 'يافعين',
    'Romance': 'رومانسية',
    'Magic': 'سحر',
    'Adventure': 'مغامرة',
    'Fiction': 'أدب',
    'Historical': 'تاريخي',
    'Family': 'عائلة',
    'Horror': 'رعب',
    'Gothic': 'قوطي',
    'Contemporary': 'معاصر',
    'Humor': 'فكاهة',
    'Small Town': 'بلدة صغيرة',
    'Poetry': 'شعر',
    'Gaming': 'ألعاب',
    'Friendship': 'صداقة',
    'Dark Academia': 'أكاديميا داكنة',
    'Mystery': 'غموض',
    'Dragons': 'تنانين',
    'New Adult': 'بالغون',
  };
}

/// A book "mood" — a motif glyph plus a short italic descriptor, derived from
/// the book's first category. Used on the details hero (the prototype's
/// `moodFor`). Glyphs: ✦ fantasy/magic/dragons, ☾ horror/gothic, ♥ romance,
/// ❝ poetry, ❦ historical, ✺ default.
@immutable
class BookMood {
  final String motif;
  final String label;
  const BookMood(this.motif, this.label);

  static BookMood of(String? firstCategory, {required bool isArabic}) {
    final c = firstCategory ?? '';
    BookMood m(String motif, String en, String ar) =>
        BookMood(motif, isArabic ? ar : en);
    if (const {'Fantasy', 'Magic', 'Dragons'}.contains(c)) {
      return m('✦', 'An enchanting fantasy', 'خيالٌ ساحر');
    }
    if (const {'Horror', 'Gothic'}.contains(c)) {
      return m('☾', 'A haunting tale', 'حكايةٌ مرعبة');
    }
    if (c == 'Romance') return m('♥', 'A swoony romance', 'رومانسيةٌ آسرة');
    if (c == 'Poetry') return m('❝', 'Lyrical & tender', 'شعرٌ رقيق');
    if (c == 'Historical') return m('❦', 'A sweeping epic', 'ملحمةٌ تاريخية');
    if (c == 'Dark Academia') return m('✦', 'Moody & cerebral', 'غموضٌ وفِكر');
    return m('✺', 'A captivating read', 'قراءةٌ آسرة');
  }
}
