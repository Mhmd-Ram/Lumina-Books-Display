import 'package:flutter/material.dart';

import '../../features/catalog/models/book.dart';

/// The three brand colors that drive a book's generated gradient cover.
///
/// The Lumina design has no cover image assets — every cover is a vibrant CSS
/// gradient built from a per-book `c1/c2/c3` palette. Books from the Open
/// Library API don't carry such a palette, so we derive a stable one from the
/// book's id (falling back to its title) via a small deterministic hash. The
/// same book therefore always gets the same cover across launches.
@immutable
class BookPalette {
  final Color c1;
  final Color c2;
  final Color c3;

  const BookPalette(this.c1, this.c2, this.c3);

  /// A curated set of vibrant, on-brand palettes (the prototype's book colors).
  static const List<BookPalette> _palettes = [
    BookPalette(Color(0xFF6D2BD6), Color(0xFFB5179E), Color(0xFFF15BB5)),
    BookPalette(Color(0xFF4361EE), Color(0xFF4CC9F0), Color(0xFF7B2FF7)),
    BookPalette(Color(0xFFFF6B4A), Color(0xFFFF9E45), Color(0xFFFF5277)),
    BookPalette(Color(0xFF0B6E4F), Color(0xFF14854F), Color(0xFF2A9D8F)),
    BookPalette(Color(0xFFFF5D8F), Color(0xFFFF8FB1), Color(0xFFFFB05C)),
    BookPalette(Color(0xFFE8A317), Color(0xFFF4B942), Color(0xFFFF7B3D)),
    BookPalette(Color(0xFF0FB8AD), Color(0xFF1CC9C0), Color(0xFF4361EE)),
    BookPalette(Color(0xFF5A4FE0), Color(0xFF8A7CFF), Color(0xFFC04CFF)),
    BookPalette(Color(0xFF3A0CA3), Color(0xFF7209B7), Color(0xFF4361EE)),
    BookPalette(Color(0xFFC2143C), Color(0xFFFF5A3C), Color(0xFFFF9E45)),
    BookPalette(Color(0xFF7A1F2B), Color(0xFFB8860B), Color(0xFFE0A458)),
    BookPalette(Color(0xFF1E3A8A), Color(0xFF2A9D8F), Color(0xFF4CC9F0)),
  ];

  static BookPalette of(Book book) {
    final key = book.id.isNotEmpty ? book.id : book.title;
    return _palettes[_hash(key) % _palettes.length];
  }

  /// FNV-1a 32-bit — a tiny, stable string hash (Dart's `String.hashCode` is not
  /// guaranteed stable across runs, which would re-roll covers each launch).
  static int _hash(String s) {
    var h = 0x811c9dc5;
    for (final c in s.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0xffffffff;
    }
    return h;
  }

  /// The cover gradient layers, painted bottom-to-top in a [Stack]:
  /// a base `c1→c2` linear gradient, a `c3` radial tint at the bottom-right,
  /// and a soft white highlight at the top-left.
  Gradient get baseGradient => LinearGradient(
        begin: const Alignment(-0.45, -0.9),
        end: const Alignment(0.45, 0.9),
        colors: [c1, c2],
      );

  Gradient get accentGradient => RadialGradient(
        center: const Alignment(0.72, 1.0),
        radius: 1.2,
        colors: [c3, c3.withValues(alpha: 0)],
        stops: const [0.0, 0.6],
      );

  Gradient get highlightGradient => RadialGradient(
        center: const Alignment(-0.72, -0.88),
        radius: 1.0,
        colors: [
          Colors.white.withValues(alpha: 0.42),
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.46],
      );

  /// `linear-gradient(135deg, c1, c2)` — used for buttons and the favourite
  /// circle in the details sheet.
  LinearGradient get button => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [c1, c2],
      );

  /// Soft color glow behind the details hero / featured card.
  RadialGradient get glow => RadialGradient(
        center: const Alignment(0, -0.2),
        radius: 0.9,
        colors: [c1, c2.withValues(alpha: 0.6), c2.withValues(alpha: 0)],
        stops: const [0.0, 0.55, 0.8],
      );

  /// The dark, color-matched background for the details sheet — two radial
  /// tints of the book colors over the fixed dark base.
  Gradient detailBackground() => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFF1B1622), Color(0xFF141019), Color(0xFF0E0B13)],
        stops: const [0.0, 0.55, 1.0],
      );
}
