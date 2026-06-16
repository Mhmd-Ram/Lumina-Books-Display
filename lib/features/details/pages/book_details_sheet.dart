import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/theme/lumina_context.dart';
import '../../../core/theme/lumina_tokens.dart';
import '../../../core/util/book_display.dart';
import '../../../core/util/book_palette.dart';
import '../../../core/widgets/gradient_cover.dart';
import '../../catalog/models/book.dart';
import '../../favorites/widgets/favorite_heart.dart';

/// Pushes the always-dark Book Details sheet with the signature 3D book-open
/// transition. The route is opaque and instantaneous; the cover "flap" inside
/// the sheet performs the open/close animation.
Future<void> openBookDetails(BuildContext context, Book book) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (_, _, _) => BookDetailsSheet(book: book),
    ),
  );
}

/// Book Details — always dark, background color-matched to the book. Tapping a
/// cover anywhere opens it; the book cover swings open (3D `rotateY`) to reveal
/// the meta, info grid, categories and ISBNs, then swings shut on close.
class BookDetailsSheet extends StatefulWidget {
  final Book book;
  const BookDetailsSheet({super.key, required this.book});

  @override
  State<BookDetailsSheet> createState() => _BookDetailsSheetState();
}

class _BookDetailsSheetState extends State<BookDetailsSheet>
    with SingleTickerProviderStateMixin {
  /// Drives the cover flap: 0 = closed (cover facing the reader), 1 = fully
  /// open (cover swung 168° away, details revealed).
  late final AnimationController _flap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  /// Brief hold showing the closed cover before it swings open / after it swings
  /// shut, so the book-open/close transition reads clearly.
  static const Duration _hold = Duration(milliseconds: 180);

  /// The flap's back faces the reader past 90°, so it's hidden from this point
  /// (168° × value > 90° → value > 0.536), revealing the details beneath.
  static const double _hideThreshold = 90 / 168;

  bool _isbnOpen = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    // Show the closed cover briefly, then swing it open.
    Future.delayed(_hold, () {
      if (mounted) _flap.forward();
    });
    _flap.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && _closing && mounted) {
        // Linger on the closed cover briefly before leaving.
        Future.delayed(_hold, () {
          if (mounted) Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _flap.dispose();
    super.dispose();
  }

  void _close() {
    if (_closing) return;
    _closing = true;
    _flap.reverse();
  }

  Future<void> _getBook() async {
    final link = widget.book.infoLink;
    final uri = link == null ? null : Uri.tryParse(link);
    final ok = uri != null &&
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final palette = BookPalette.of(book);
    final isArabic = context.isArabic;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        // expand so the Stack always fills the (loosely-constrained) body — the
        // children are all positioned, so without this it would collapse to 0.
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Color-matched dark backdrop.
            Positioned.fill(child: _DetailBackground(palette: palette)),

            // Floating mood glyphs in the hero area.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 430,
              child: _MoodLayer(book: book, palette: palette),
            ),

            // Scrollable details content (revealed as the flap opens).
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _flap,
                builder: (context, child) {
                  final reveal = ((_flap.value - 0.4) / 0.4).clamp(0.0, 1.0);
                  return Opacity(
                    opacity: reveal,
                    child: Transform.translate(
                      offset: Offset(0, (1 - reveal) * 16),
                      child: child,
                    ),
                  );
                },
                child: _DetailsContent(
                  book: book,
                  palette: palette,
                  isbnOpen: _isbnOpen,
                  onToggleIsbn: () => setState(() => _isbnOpen = !_isbnOpen),
                  onClose: _close,
                  onGetBook: _getBook,
                ),
              ),
            ),

            // The 3D book-cover flap — kept inside a Positioned.fill so it's
            // always a positioned child (otherwise the SizedBox.shrink it
            // becomes when open would collapse the Stack to zero size).
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _flap,
                builder: (context, _) {
                  if (_flap.value > _hideThreshold) {
                    return const SizedBox.shrink();
                  }
                  final angle = _flap.value * 168 * math.pi / 180 *
                      (isArabic ? 1 : -1);
                  return Transform(
                    alignment: isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0009)
                      ..rotateY(angle),
                    child: IgnorePointer(
                      child: _Flap(book: book, palette: palette),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two radial tints of the book colors over the fixed dark base.
class _DetailBackground extends StatelessWidget {
  final BookPalette palette;
  const _DetailBackground({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(decoration: BoxDecoration(gradient: palette.detailBackground())),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -1.1),
              radius: 1.2,
              colors: [palette.c1.withValues(alpha: 0.4), palette.c1.withValues(alpha: 0)],
              stops: const [0, 0.58],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.84, -0.92),
              radius: 0.9,
              colors: [palette.c3.withValues(alpha: 0.25), palette.c3.withValues(alpha: 0)],
              stops: const [0, 0.52],
            ),
          ),
        ),
      ],
    );
  }
}

/// The full-screen book cover that swings open. Built on [GradientCover] so it
/// matches the book's generated cover exactly.
class _Flap extends StatelessWidget {
  final Book book;
  final BookPalette palette;
  const _Flap({required this.book, required this.palette});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) => GradientCover(
        palette: palette,
        width: c.maxWidth,
        height: c.maxHeight,
        radius: 0,
        decor: CoverDecor.topRight,
        imageUrl: book.largeThumbnail,
        filterQuality: FilterQuality.high,
        child: Stack(
          children: [
            // Spine shadow (left) + page highlight (right).
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 34,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.35), Colors.black.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 46),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome,
                        size: 22, color: Colors.white.withValues(alpha: 0.85)),
                    const SizedBox(height: 18),
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: context.serif(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.04,
                        letterSpacing: context.isArabic ? null : -0.84,
                        shadows: const [
                          Shadow(color: Color(0x59000000), blurRadius: 30, offset: Offset(0, 4)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book.authorsText.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: context.sans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.85),
                        letterSpacing: context.isArabic ? null : 2.3,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 46,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The revealed details: top bar, hero, meta, info grid, categories, ISBNs and
/// the fixed "Get the Book" bar.
class _DetailsContent extends StatelessWidget {
  final Book book;
  final BookPalette palette;
  final bool isbnOpen;
  final VoidCallback onToggleIsbn;
  final VoidCallback onClose;
  final Future<void> Function() onGetBook;

  const _DetailsContent({
    required this.book,
    required this.palette,
    required this.isbnOpen,
    required this.onToggleIsbn,
    required this.onClose,
    required this.onGetBook,
  });

  static const Color _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final isArabic = context.isArabic;
    final mood = BookMood.of(book.firstCategory, isArabic: isArabic);

    return Stack(
      children: [
        SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 132),
            children: [
              // Top bar.
              Row(
                children: [
                  _CircleButton(
                    icon: isArabic ? Icons.chevron_right : Icons.chevron_left,
                    onTap: onClose,
                  ),
                  Expanded(
                    child: Text(
                      s.bookDetails.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: context.sans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _white.withValues(alpha: 0.55),
                        letterSpacing: context.eyebrowTracking(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
              const SizedBox(height: 18),

              // Hero cover with glow + floating favourite button.
              Center(child: _Hero(book: book, palette: palette)),
              const SizedBox(height: 26),

              // Title / author / mood / rating.
              Text(
                book.title,
                textAlign: TextAlign.center,
                style: context.serif(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                  color: _white,
                  height: 1.06,
                  letterSpacing: isArabic ? null : -0.5,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '${s.by} ${book.authorsText}',
                textAlign: TextAlign.center,
                style: context.sans(
                  fontSize: 14.5,
                  color: _white.withValues(alpha: 0.62),
                ),
              ),
              const SizedBox(height: 11),
              _MoodLine(mood: mood, color: palette.c3),
              const SizedBox(height: 14),
              Center(child: _RatingPill(book: book)),
              const SizedBox(height: 26),

              // Info grid (2×2).
              _InfoGrid(book: book),
              const SizedBox(height: 26),

              // Categories.
              if (book.categories.isNotEmpty) ...[
                _SectionLabel(s.categories),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: [
                    for (final c in book.categories.take(8))
                      _CategoryPill(s.category(c)),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // ISBN accordion.
              if (book.isbns.isNotEmpty)
                _IsbnAccordion(
                  isbns: book.isbns,
                  open: isbnOpen,
                  onToggle: onToggleIsbn,
                  label: s.isbns,
                ),
            ],
          ),
        ),

        // Fixed "Get the Book" bar.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _GetBookBar(palette: palette, label: s.getBook, onTap: onGetBook),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  final Book book;
  final BookPalette palette;
  const _Hero({required this.book, required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212 + 28,
      height: 312 + 28,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Glow.
          Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              gradient: palette.glow,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          GradientCover(
            palette: palette,
            width: 212,
            height: 312,
            radius: 18,
            decor: CoverDecor.topRight,
            imageUrl: book.largeThumbnail,
            filterQuality: FilterQuality.high,
            scrim: 0.35,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            shadow: const [
              BoxShadow(
                color: Color(0xCC000000),
                blurRadius: 80,
                offset: Offset(0, 46),
                spreadRadius: -32,
              ),
            ],
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                book.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.serif(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.04,
                ),
              ),
            ),
          ),
          // Floating favourite button at the corner.
          Positioned(
            right: 0,
            bottom: 0,
            child: FavoriteHeart(
              book: book,
              size: 54,
              iconSize: 24,
              backgroundGradient: palette.button,
              filledColor: Colors.white,
              outlineColor: Colors.white,
              shadow: const [
                BoxShadow(
                  color: Color(0x99000000),
                  blurRadius: 30,
                  offset: Offset(0, 16),
                  spreadRadius: -12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodLine extends StatelessWidget {
  final BookMood mood;
  final Color color;
  const _MoodLine({required this.mood, required this.color});

  @override
  Widget build(BuildContext context) {
    final glyph = Text(
      mood.motif,
      style: TextStyle(fontSize: 17, color: color),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        glyph,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            mood.label,
            textAlign: TextAlign.center,
            style: context.serif(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ),
        const SizedBox(width: 8),
        glyph,
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  final Book book;
  const _RatingPill({required this.book});

  @override
  Widget build(BuildContext context) {
    final rating = book.ratingLabel;
    if (rating == null) {
      return Text(
        'Not yet rated',
        style: context.sans(
          fontSize: 13,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 18, color: LuminaTokens.starDetails),
          const SizedBox(width: 6),
          Text(
            rating,
            style: context.sans(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '(${book.ratingsCount ?? 0})',
            style: context.sans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final Book book;
  const _InfoGrid({required this.book});

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final cells = [
      (s.publisher, book.publisher ?? '—'),
      (s.published, book.year),
      (s.pages, book.pageCount?.toString() ?? '—'),
      (s.language, book.languageLabel),
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _InfoCard(label: cells[0].$1, value: cells[0].$2)),
            const SizedBox(width: 11),
            Expanded(child: _InfoCard(label: cells[1].$1, value: cells[1].$2)),
          ],
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(child: _InfoCard(label: cells[2].$1, value: cells[2].$2)),
            const SizedBox(width: 11),
            Expanded(child: _InfoCard(label: cells[3].$1, value: cells[3].$2)),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: context.sans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.5),
              letterSpacing: context.eyebrowTracking(10.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.serif(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: context.sans(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: Colors.white.withValues(alpha: 0.5),
        letterSpacing: context.eyebrowTracking(11.5),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String text;
  const _CategoryPill(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        text,
        style: context.sans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.92),
        ),
      ),
    );
  }
}

class _IsbnAccordion extends StatelessWidget {
  final List<String> isbns;
  final bool open;
  final VoidCallback onToggle;
  final String label;

  const _IsbnAccordion({
    required this.isbns,
    required this.open,
    required this.onToggle,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  Text(
                    label,
                    style: context.sans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${isbns.length}',
                      style: context.sans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.expand_more,
                        size: 22, color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              child: Column(
                children: [
                  for (final code in isbns) _IsbnRow(code: code),
                ],
              ),
            ),
            crossFadeState:
                open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 280),
          ),
        ],
      ),
    );
  }
}

class _IsbnRow extends StatelessWidget {
  final String code;
  const _IsbnRow({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              code,
              style: context.sans(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.82),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            'ISBN-13',
            style: context.sans(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _GetBookBar extends StatelessWidget {
  final BookPalette palette;
  final String label;
  final Future<void> Function() onTap;

  const _GetBookBar({
    required this.palette,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 18, 24, 26 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x000E0B13), Color(0xEB0E0B13)],
          stops: [0, 0.42],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: palette.button,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x99000000),
                blurRadius: 38,
                offset: Offset(0, 20),
                spreadRadius: -14,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 21, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                label,
                style: context.sans(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
        ),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}

/// Floating motif glyphs that drift in the hero area.
class _MoodLayer extends StatefulWidget {
  final Book book;
  final BookPalette palette;
  const _MoodLayer({required this.book, required this.palette});

  @override
  State<_MoodLayer> createState() => _MoodLayerState();
}

class _MoodLayerState extends State<_MoodLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  // top%, left%, size, opacity, phase
  static const List<List<double>> _positions = [
    [0.07, 0.13, 32, 0.55, 0.0],
    [0.15, 0.76, 22, 0.42, 0.6],
    [0.40, 0.07, 20, 0.40, 1.1],
    [0.05, 0.50, 15, 0.32, 0.3],
    [0.30, 0.86, 27, 0.46, 0.9],
    [0.50, 0.64, 16, 0.32, 1.4],
  ];

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final mood = BookMood.of(widget.book.firstCategory, isArabic: isArabic);
    final colors = [widget.palette.c1, widget.palette.c2, widget.palette.c3];

    return LayoutBuilder(
      builder: (context, c) {
        return AnimatedBuilder(
          animation: _float,
          builder: (context, _) {
            return Stack(
              children: [
                for (var i = 0; i < _positions.length; i++)
                  _glyph(i, c.maxWidth, c.maxHeight, mood.motif, colors[i % 3],
                      isArabic),
              ],
            );
          },
        );
      },
    );
  }

  Widget _glyph(int i, double w, double h, String motif, Color color,
      bool isArabic) {
    final p = _positions[i];
    final phase = (_float.value * 2 * math.pi) + p[4];
    final dy = math.sin(phase) * 9;
    return Positioned(
      top: h * p[0] + dy,
      left: isArabic ? null : w * p[1],
      right: isArabic ? w * p[1] : null,
      child: Text(
        motif,
        style: TextStyle(
          fontSize: p[2],
          color: color.withValues(alpha: p[3]),
          shadows: [Shadow(color: color, blurRadius: 18)],
        ),
      ),
    );
  }
}
