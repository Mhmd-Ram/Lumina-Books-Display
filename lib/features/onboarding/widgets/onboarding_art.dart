import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/compass_medallion.dart';

/// The floating illustration for each onboarding slide, recreated from the
/// design comp's SVGs as [CustomPaint] (no assets):
///   0 — "cosmos": the gold compass medallion (reuses [CompassMedallion]).
///   1 — "map": a gold constellation route with node stars.
///   2 — "library": a stack of books with an open book above.
/// Gold / navy shift with the active theme.
class OnboardingArt extends StatelessWidget {
  final int index;
  const OnboardingArt({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    if (index == 0) return const CompassMedallion(size: 172);

    final dark = context.lumina.isDark;
    return SizedBox(
      width: 178,
      height: 178,
      child: CustomPaint(
        painter: index == 1 ? _MapPainter(dark) : _LibraryPainter(dark),
      ),
    );
  }
}

Color _gold(bool dark) => dark ? const Color(0xFFE7C56B) : const Color(0xFFA97C2E);
Color _navy(bool dark) => dark ? const Color(0xFF0F1023) : const Color(0xFF21305E);

/// Draws a "✦" glyph centered on [center] in gold.
void _sparkle(Canvas canvas, Offset center, double fontSize, Color color) {
  final tp = TextPainter(
    text: TextSpan(
      text: '✦',
      style: TextStyle(fontSize: fontSize, color: color),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
}

/// Slide 2 — constellation route (comp viewBox 0–150).
class _MapPainter extends CustomPainter {
  final bool dark;
  _MapPainter(this.dark);

  static const _nodes = [
    (Offset(26, 110), 3.4),
    (Offset(52, 74), 3.0),
    (Offset(84, 90), 3.8),
    (Offset(108, 50), 3.0),
    (Offset(132, 66), 3.2),
  ];
  static const _faint = [Offset(44, 34), Offset(120, 118), Offset(70, 26)];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 150.0;
    final gold = _gold(dark);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = gold;
    final path = Path()..moveTo(_nodes.first.$1.dx * s, _nodes.first.$1.dy * s);
    for (final n in _nodes.skip(1)) {
      path.lineTo(n.$1.dx * s, n.$1.dy * s);
    }
    canvas.drawPath(path, line);

    final dot = Paint()..color = gold;
    for (final n in _nodes) {
      canvas.drawCircle(n.$1 * s, n.$2 * s, dot);
    }
    final faintDot = Paint()..color = gold.withValues(alpha: 0.55);
    for (final f in _faint) {
      canvas.drawCircle(f * s, 2 * s, faintDot);
    }
    _sparkle(canvas, const Offset(108, 40) * s, 14 * s, gold);
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.dark != dark;
}

/// Slide 3 — stacked books + open book (comp viewBox 0–150).
class _LibraryPainter extends CustomPainter {
  final bool dark;
  _LibraryPainter(this.dark);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 150.0;
    final gold = _gold(dark);
    final navy = _navy(dark);
    const mid = Color(0xFFB98E37);
    const bright = Color(0xFFE7C56B);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeJoin = StrokeJoin.round
      ..color = gold;

    void book(double x, double y, double w, Color fill) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x * s, y * s, w * s, 16 * s),
        Radius.circular(3 * s),
      );
      canvas.drawRRect(rect, Paint()..color = fill);
      canvas.drawRRect(rect, stroke);
    }

    book(34, 96, 82, navy);
    book(40, 78, 70, mid);
    book(36, 60, 78, navy);

    // Open book (translated from the comp's SVG path).
    final open = Path()
      ..moveTo(75 * s, 30 * s)
      ..cubicTo(73 * s, 28 * s, 70 * s, 27 * s, 66 * s, 27 * s)
      ..lineTo(61 * s, 27 * s)
      ..lineTo(61 * s, 49 * s)
      ..lineTo(66 * s, 49 * s)
      ..cubicTo(70 * s, 49 * s, 73 * s, 50 * s, 75 * s, 52 * s)
      ..cubicTo(77 * s, 50 * s, 80 * s, 49 * s, 84 * s, 49 * s)
      ..lineTo(89 * s, 49 * s)
      ..lineTo(89 * s, 27 * s)
      ..lineTo(84 * s, 27 * s)
      ..cubicTo(80 * s, 27 * s, 77 * s, 28 * s, 75 * s, 30 * s)
      ..close();
    canvas.drawPath(open, Paint()..color = bright);
    canvas.drawPath(
      open,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * s
        ..strokeJoin = StrokeJoin.round
        ..color = gold,
    );
    // Center spine.
    canvas.drawLine(
      Offset(75 * s, 30 * s),
      Offset(75 * s, 52 * s),
      Paint()
        ..strokeWidth = 1.6 * s
        ..color = gold,
    );

    _sparkle(canvas, const Offset(96, 22) * s, 15 * s, gold);
    _sparkle(canvas, const Offset(44, 20) * s, 11 * s, gold.withValues(alpha: 0.6));
  }

  @override
  bool shouldRepaint(covariant _LibraryPainter oldDelegate) => oldDelegate.dark != dark;
}
