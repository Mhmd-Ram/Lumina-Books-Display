import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The splash brand mark: a navy disc with a gold bezel and an 8-point gold
/// compass star (two overlaid 4-point stars) with a centre gem. Drawn as a
/// [CustomPaint] in a 100×100 design space, scaled to [size].
class CompassMedallion extends StatelessWidget {
  final double size;
  const CompassMedallion({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CompassPainter()),
    );
  }
}

class _CompassPainter extends CustomPainter {
  static const _disc = Color(0xFF21305E);
  static const _bezel = Color(0xFFCBA24C);
  static const _starInner = Color(0xFFB98E37);
  static const _starOuter = Color(0xFFE7C56B);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100.0;
    final center = Offset(50 * s, 50 * s);

    // Navy disc + gold bezel ring.
    canvas.drawCircle(center, 47 * s, Paint()..color = _disc);
    canvas.drawCircle(
      center,
      47 * s,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5 * s
        ..color = _bezel,
    );
    canvas.drawCircle(
      center,
      40 * s,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1 * s
        ..color = _bezel.withValues(alpha: 0.5),
    );

    // Inner 4-point star, rotated 45°.
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(math.pi / 4);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawPath(
      _poly(s, const [
        Offset(50, 28), Offset(53, 47), Offset(72, 50), Offset(53, 53),
        Offset(50, 72), Offset(47, 53), Offset(28, 50), Offset(47, 47),
      ]),
      Paint()..color = _starInner,
    );
    canvas.restore();

    // Outer 4-point star.
    canvas.drawPath(
      _poly(s, const [
        Offset(50, 15), Offset(54.5, 45.5), Offset(85, 50), Offset(54.5, 54.5),
        Offset(50, 85), Offset(45.5, 54.5), Offset(15, 50), Offset(45.5, 45.5),
      ]),
      Paint()..color = _starOuter,
    );

    // Centre gem.
    canvas.drawCircle(center, 5 * s, Paint()..color = _disc);
    canvas.drawCircle(
      center,
      5 * s,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..color = _starOuter,
    );
  }

  Path _poly(double s, List<Offset> points) {
    final path = Path()..moveTo(points.first.dx * s, points.first.dy * s);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx * s, p.dy * s);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
