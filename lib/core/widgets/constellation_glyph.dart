import 'package:flutter/material.dart';

import '../theme/lumina_context.dart';

/// A self-drawing constellation: gold lines trace themselves between star dots,
/// hold, fade, and redraw on a gentle loop. Used as the motif for empty states
/// (a five-point star for "no results", a heart for "no favorites").
class ConstellationGlyph extends StatefulWidget {
  /// Vertices in normalized [0,1] space, drawn in order as a polyline.
  final List<Offset> points;
  final double size;
  final Color? color;

  const ConstellationGlyph({
    super.key,
    required this.points,
    this.size = 96,
    this.color,
  });

  /// A five-pointed star asterism.
  factory ConstellationGlyph.star({double size = 96, Color? color}) =>
      ConstellationGlyph(points: _star, size: size, color: color);

  /// A heart-shaped constellation.
  factory ConstellationGlyph.heart({double size = 96, Color? color}) =>
      ConstellationGlyph(points: _heart, size: size, color: color);

  static const List<Offset> _star = [
    Offset(0.50, 0.06),
    Offset(0.759, 0.856),
    Offset(0.082, 0.364),
    Offset(0.918, 0.364),
    Offset(0.241, 0.856),
    Offset(0.50, 0.06),
  ];

  static const List<Offset> _heart = [
    Offset(0.50, 0.90),
    Offset(0.22, 0.58),
    Offset(0.10, 0.36),
    Offset(0.18, 0.20),
    Offset(0.34, 0.18),
    Offset(0.50, 0.32),
    Offset(0.66, 0.18),
    Offset(0.82, 0.20),
    Offset(0.90, 0.36),
    Offset(0.78, 0.58),
    Offset(0.50, 0.90),
  ];

  @override
  State<ConstellationGlyph> createState() => _ConstellationGlyphState();
}

class _ConstellationGlyphState extends State<ConstellationGlyph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.lumina.accent;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final v = _controller.value;
          // Draw over the first ~62%, hold, then fade out before looping.
          final progress = Curves.easeInOut.transform((v / 0.62).clamp(0.0, 1.0));
          final double opacity;
          if (v < 0.08) {
            opacity = v / 0.08;
          } else if (v < 0.85) {
            opacity = 1;
          } else {
            opacity = 1 - (v - 0.85) / 0.15;
          }
          return Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: CustomPaint(
              painter: _ConstellationPainter(widget.points, progress, color),
            ),
          );
        },
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  final List<Offset> points;
  final double progress;
  final Color color;

  _ConstellationPainter(this.points, this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final pts = [
      for (final p in points) Offset(p.dx * size.width, p.dy * size.height),
    ];

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    final cumulative = <double>[0];
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
      cumulative.add(cumulative[i - 1] + (pts[i] - pts[i - 1]).distance);
    }
    final total = cumulative.last;
    final drawn = total * progress;

    // The portion of the polyline drawn so far.
    final partial = Path();
    var remaining = drawn;
    for (final metric in path.computeMetrics()) {
      if (remaining <= 0) break;
      final take = remaining.clamp(0.0, metric.length);
      partial.addPath(metric.extractPath(0, take), Offset.zero);
      remaining -= take;
    }

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color.withValues(alpha: 0.22)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawPath(partial, glow);
    canvas.drawPath(partial, line);

    // Star dots, lit as the line reaches them.
    for (var i = 0; i < pts.length; i++) {
      if (cumulative[i] > drawn + 0.5) continue;
      final appear = ((drawn - cumulative[i]) / 14).clamp(0.0, 1.0);
      final radius = 2.2 * (0.6 + 0.4 * appear);
      canvas.drawCircle(
        pts[i],
        radius + 2.6,
        Paint()..color = color.withValues(alpha: 0.22 * appear),
      );
      canvas.drawCircle(
        pts[i],
        radius,
        Paint()..color = color.withValues(alpha: (0.9 * appear).clamp(0.0, 1.0)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter old) =>
      old.progress != progress || old.color != color;
}
