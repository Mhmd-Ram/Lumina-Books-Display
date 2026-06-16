class Book {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? publisher;
  final String? publishedDate;
  final String? description;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? maturityRating;
  final String? language;
  final String? thumbnail;
  final List<String> isbns;
  final String? infoLink;

  const Book({
    required this.id,
    required this.title,
    this.subtitle,
    this.authors = const [],
    this.publisher,
    this.publishedDate,
    this.description,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.maturityRating,
    this.language,
    this.thumbnail,
    this.isbns = const [],
    this.infoLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final v = (json['volumeInfo'] as Map<String, dynamic>?) ?? const {};
    final images = v['imageLinks'] as Map<String, dynamic>?;
    return Book(
      id: json['id'] as String? ?? '',
      title: v['title'] as String? ?? 'Untitled',
      subtitle: v['subtitle'] as String?,
      authors: (v['authors'] as List?)?.cast<String>() ?? const [],
      publisher: v['publisher'] as String?,
      publishedDate: v['publishedDate'] as String?,
      description: cleanText(v['description'] as String?),
      pageCount: v['pageCount'] as int?,
      categories: (v['categories'] as List?)?.cast<String>() ?? const [],
      averageRating: (v['averageRating'] as num?)?.toDouble(),
      ratingsCount: v['ratingsCount'] as int?,
      maturityRating: v['maturityRating'] as String?,
      language: v['language'] as String?,
      thumbnail: (images?['thumbnail'] ?? images?['smallThumbnail'] as String?)
          ?.toString().replaceFirst('http://', 'https://'),
      isbns: ((v['industryIdentifiers'] as List?) ?? const [])
          .map((e) => '${e['type']}: ${e['identifier']}').toList(),
      infoLink: v['infoLink'] as String?,
    );
  }

  factory Book.fromOpenLibrary(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? '';
    final id = key.replaceFirst('/works/', '');
    final coverId = json['cover_i'];
    final thumbnail = coverId != null ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg' : null;

    String? desc;
    final firstSentence = json['first_sentence'];
    if (firstSentence is String) {
      desc = cleanText(firstSentence);
    } else if (firstSentence is Map && firstSentence['value'] is String) {
      desc = cleanText(firstSentence['value'] as String);
    }

    return Book(
      id: id,
      title: json['title'] as String? ?? 'Untitled',
      subtitle: json['subtitle'] as String?,
      authors: (json['author_name'] as List?)?.cast<String>() ?? const [],
      publisher: (json['publisher'] as List?)?.firstOrNull as String?,
      publishedDate: json['first_publish_year']?.toString(),
      description: desc,
      pageCount: json['number_of_pages_median'] as int?,
      categories: (json['subject'] as List?)?.cast<String>() ?? const [],
      averageRating: (json['ratings_average'] as num?)?.toDouble(),
      ratingsCount: json['ratings_count'] as int?,
      maturityRating: null,
      language: (json['language'] as List?)?.firstOrNull as String?,
      thumbnail: thumbnail,
      isbns: (json['isbn'] as List?)?.cast<String>() ?? const [],
      infoLink: id.isNotEmpty ? 'https://openlibrary.org/works/$id' : null,
    );
  }

  // Display helpers the UI can use directly:
  String get authorsText => authors.isEmpty ? 'Unknown author' : authors.join(', ');
  String get year => (publishedDate != null && publishedDate!.length >= 4)
      ? publishedDate!.substring(0, 4) : '—';
  String get ratingText => averageRating == null
      ? 'Not yet rated'
      : '${averageRating!.toStringAsFixed(1)} (${ratingsCount ?? 0})';

  static String? cleanText(String? s) =>
      s?.replaceAll(RegExp(r'<[^>]*>'), '').replaceAll('&nbsp;', ' ').trim();
}
