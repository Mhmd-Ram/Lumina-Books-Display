import '../../features/catalog/models/book.dart';

/// Presentation-only helpers for the Lumina UI, kept as an extension so the
/// shared [Book] data contract (and its unit tests) stay untouched.
extension BookDisplay on Book {
  /// Serif monogram shown on small search thumbnails.
  String get initial =>
      title.trim().isEmpty ? 'L' : title.trim()[0].toUpperCase();

  /// One-decimal rating ("4.3"), or null when the book has no rating.
  String? get ratingLabel => averageRating?.toStringAsFixed(1);

  /// Compact ratings count ("1.2k", "212").
  String get countLabel {
    final n = ratingsCount ?? 0;
    if (n < 1000) return '$n';
    return '${(n / 1000).toStringAsFixed(1).replaceAll('.0', '')}k';
  }

  /// A higher-resolution cover URL for large surfaces (the featured carousel,
  /// the details hero, and the open/close flap) so upscaling doesn't blur the
  /// art. Open Library serves `-L` (large) covers; Google Books serves bigger
  /// art at a higher `zoom`. Falls back to the medium [thumbnail] for both.
  String? get largeThumbnail {
    final url = thumbnail;
    if (url == null) return null;
    return url.replaceAll('-M.jpg', '-L.jpg').replaceAll('zoom=1', 'zoom=3');
  }

  /// Uppercased language code for the meta row ("ENG"), or "—".
  String get languageLabel => (language ?? '—').toUpperCase();

  /// First category, or empty string.
  String get firstCategory => categories.isNotEmpty ? categories.first : '';
}
