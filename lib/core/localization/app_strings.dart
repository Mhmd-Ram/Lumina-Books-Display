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

  // Onboarding (3 slides + controls).
  final String onbTitle1;
  final String onbBody1;
  final String onbTitle2;
  final String onbBody2;
  final String onbTitle3;
  final String onbBody3;
  final String skip;
  final String next;
  final String getStarted;

  // Auth — shared fields + login + sign-up.
  final String email;
  final String password;
  final String emailHint;
  final String passwordHintLogin;
  final String passwordHintSignup;
  final String orDivider;
  final String continueGoogle;
  final String welcomeBack;
  final String loginSub;
  final String forgotPassword;
  final String logIn;
  final String newToLumina;
  final String createAccount;
  final String createYourAccount;
  final String signupSub;
  final String fullName;
  final String fullNameHint;
  final String signUp;
  final String alreadyHaveAccount;
  final String tos;

  // Settings.
  final String navSettings;
  final String settings;
  final String preferences;
  final String darkMode;
  final String languageValue;
  final String newReleaseAlerts;
  final String account;
  final String editProfile;
  final String editShort;
  final String changePassword;
  final String privacyData;
  final String about;
  final String helpCenter;
  final String version;
  final String logOut;

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
    required this.onbTitle1,
    required this.onbBody1,
    required this.onbTitle2,
    required this.onbBody2,
    required this.onbTitle3,
    required this.onbBody3,
    required this.skip,
    required this.next,
    required this.getStarted,
    required this.email,
    required this.password,
    required this.emailHint,
    required this.passwordHintLogin,
    required this.passwordHintSignup,
    required this.orDivider,
    required this.continueGoogle,
    required this.welcomeBack,
    required this.loginSub,
    required this.forgotPassword,
    required this.logIn,
    required this.newToLumina,
    required this.createAccount,
    required this.createYourAccount,
    required this.signupSub,
    required this.fullName,
    required this.fullNameHint,
    required this.signUp,
    required this.alreadyHaveAccount,
    required this.tos,
    required this.navSettings,
    required this.settings,
    required this.preferences,
    required this.darkMode,
    required this.languageValue,
    required this.newReleaseAlerts,
    required this.account,
    required this.editProfile,
    required this.editShort,
    required this.changePassword,
    required this.privacyData,
    required this.about,
    required this.helpCenter,
    required this.version,
    required this.logOut,
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
    onbTitle1: 'A universe of stories',
    onbBody1:
        'Explore books from every corner of the literary cosmos — curated, not endless.',
    onbTitle2: 'Find your constellation',
    onbBody2:
        'Personalized picks that map to the authors and genres you already love.',
    onbTitle3: 'Build your library',
    onbBody3:
        'Save favorites and keep your whole reading world in one calm place.',
    skip: 'Skip',
    next: 'Next',
    getStarted: 'Get started',
    email: 'Email',
    password: 'Password',
    emailHint: 'you@example.com',
    passwordHintLogin: '••••••••',
    passwordHintSignup: 'At least 8 characters',
    orDivider: 'or',
    continueGoogle: 'Continue with Google',
    welcomeBack: 'Welcome back',
    loginSub: 'Sign in to return to your library.',
    forgotPassword: 'Forgot password?',
    logIn: 'Log in',
    newToLumina: 'New to Lumina?',
    createAccount: 'Create an account',
    createYourAccount: 'Create your account',
    signupSub: 'Start mapping your literary cosmos.',
    fullName: 'Full name',
    fullNameHint: 'Amina Reader',
    signUp: 'Sign up',
    alreadyHaveAccount: 'Already have an account?',
    tos: "By signing up you agree to Lumina's Terms of Service and Privacy Policy.",
    navSettings: 'Settings',
    settings: 'Settings',
    preferences: 'Preferences',
    darkMode: 'Dark mode',
    languageValue: 'English',
    newReleaseAlerts: 'New release alerts',
    account: 'Account',
    editProfile: 'Edit profile',
    editShort: 'Edit',
    changePassword: 'Change password',
    privacyData: 'Privacy & data',
    about: 'About',
    helpCenter: 'Help center',
    version: 'v1.0.0',
    logOut: 'Log out',
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
    onbTitle1: 'عالمٌ من القصص',
    onbBody1: 'استكشف كتباً من كل ركن في الكون الأدبي — منتقاةً لا لا نهائية.',
    onbTitle2: 'اعثر على كوكبتك',
    onbBody2: 'اختياراتٌ مخصّصة تلائم المؤلفين والأنواع التي تحبها أصلاً.',
    onbTitle3: 'ابنِ مكتبتك',
    onbBody3: 'احفظ المفضّلة واجمع عالم قراءتك كله في مكانٍ هادئ واحد.',
    skip: 'تخطٍّ',
    next: 'التالي',
    getStarted: 'لنبدأ',
    email: 'البريد الإلكتروني',
    password: 'كلمة المرور',
    emailHint: 'you@example.com',
    passwordHintLogin: '••••••••',
    passwordHintSignup: '٨ أحرف على الأقل',
    orDivider: 'أو',
    continueGoogle: 'المتابعة عبر Google',
    welcomeBack: 'مرحباً بعودتك',
    loginSub: 'سجّل الدخول للعودة إلى مكتبتك.',
    forgotPassword: 'نسيت كلمة المرور؟',
    logIn: 'تسجيل الدخول',
    newToLumina: 'جديدٌ في لومينا؟',
    createAccount: 'أنشئ حساباً',
    createYourAccount: 'أنشئ حسابك',
    signupSub: 'ابدأ رسم كونك الأدبي.',
    fullName: 'الاسم الكامل',
    fullNameHint: 'أمينة القارئة',
    signUp: 'إنشاء حساب',
    alreadyHaveAccount: 'لديك حسابٌ بالفعل؟',
    tos: 'بالتسجيل فإنك توافق على شروط الخدمة وسياسة الخصوصية الخاصة بلومينا.',
    navSettings: 'الإعدادات',
    settings: 'الإعدادات',
    preferences: 'التفضيلات',
    darkMode: 'الوضع الداكن',
    languageValue: 'العربية',
    newReleaseAlerts: 'تنبيهات الإصدارات الجديدة',
    account: 'الحساب',
    editProfile: 'تعديل الملف الشخصي',
    editShort: 'تعديل',
    changePassword: 'تغيير كلمة المرور',
    privacyData: 'الخصوصية والبيانات',
    about: 'حول',
    helpCenter: 'مركز المساعدة',
    version: 'v1.0.0',
    logOut: 'تسجيل الخروج',
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
