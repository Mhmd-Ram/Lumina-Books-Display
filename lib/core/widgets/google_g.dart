import 'package:flutter/material.dart';

/// The four-color Google "G" mark, drawn as a [CustomPaint] so no asset or
/// package is needed. Used on the "Continue with Google" buttons. Geometry is
/// the standard Google logo in a 24×24 space, scaled to [size].
class GoogleG extends StatelessWidget {
  final double size;
  const GoogleG({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _green = Color(0xFF34A853);
  static const _yellow = Color(0xFFFBBC05);
  static const _red = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    final fill = Paint()..isAntiAlias = true;

    // Blue — right arm of the G.
    canvas.drawPath(
      Path()
        ..moveTo(23 * s, 12.3 * s)
        ..cubicTo(23 * s, 11.5 * s, 22.9 * s, 10.7 * s, 22.8 * s, 10 * s)
        ..lineTo(12 * s, 10 * s)
        ..lineTo(12 * s, 14.5 * s)
        ..lineTo(18.2 * s, 14.5 * s)
        ..cubicTo(17.9 * s, 16.1 * s, 17 * s, 17.4 * s, 15.9 * s, 18 * s)
        ..lineTo(15.9 * s, 20.9 * s)
        ..lineTo(19.6 * s, 20.9 * s)
        ..cubicTo(21.8 * s, 18.9 * s, 23 * s, 15.9 * s, 23 * s, 12.3 * s)
        ..close(),
      fill..color = _blue,
    );

    // Green — bottom curve.
    canvas.drawPath(
      Path()
        ..moveTo(12 * s, 24 * s)
        ..cubicTo(15.1 * s, 24 * s, 17.7 * s, 23 * s, 19.6 * s, 21.2 * s)
        ..lineTo(15.9 * s, 18.3 * s)
        ..cubicTo(14.9 * s, 19 * s, 13.5 * s, 19.4 * s, 12 * s, 19.4 * s)
        ..cubicTo(9 * s, 19.4 * s, 6.5 * s, 17.4 * s, 5.6 * s, 14.6 * s)
        ..lineTo(1.8 * s, 14.6 * s)
        ..lineTo(1.8 * s, 17.6 * s)
        ..cubicTo(3.7 * s, 21.4 * s, 7.6 * s, 24 * s, 12 * s, 24 * s)
        ..close(),
      fill..color = _green,
    );

    // Yellow — left curve.
    canvas.drawPath(
      Path()
        ..moveTo(5.6 * s, 14.6 * s)
        ..cubicTo(5.35 * s, 13.9 * s, 5.2 * s, 13.1 * s, 5.2 * s, 12.3 * s)
        ..cubicTo(5.2 * s, 11.5 * s, 5.35 * s, 10.7 * s, 5.6 * s, 10 * s)
        ..lineTo(5.6 * s, 7 * s)
        ..lineTo(1.8 * s, 7 * s)
        ..cubicTo(1 * s, 8.6 * s, 0.5 * s, 10.4 * s, 0.5 * s, 12.3 * s)
        ..cubicTo(0.5 * s, 14.2 * s, 1 * s, 16 * s, 1.8 * s, 17.6 * s)
        ..lineTo(5.6 * s, 14.6 * s)
        ..close(),
      fill..color = _yellow,
    );

    // Red — top curve.
    canvas.drawPath(
      Path()
        ..moveTo(12 * s, 4.8 * s)
        ..cubicTo(13.7 * s, 4.8 * s, 15.2 * s, 5.4 * s, 16.4 * s, 6.5 * s)
        ..lineTo(19.7 * s, 3.2 * s)
        ..cubicTo(17.7 * s, 1.2 * s, 15.1 * s, 0 * s, 12 * s, 0 * s)
        ..cubicTo(7.6 * s, 0 * s, 3.7 * s, 2.6 * s, 1.8 * s, 6.4 * s)
        ..lineTo(5.6 * s, 9.4 * s)
        ..cubicTo(6.5 * s, 6.6 * s, 9 * s, 4.8 * s, 12 * s, 4.8 * s)
        ..close(),
      fill..color = _red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
