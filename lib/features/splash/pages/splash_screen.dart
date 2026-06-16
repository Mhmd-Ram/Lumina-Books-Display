import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/compass_medallion.dart';

/// Branded launch splash — always parchment regardless of theme. Auto-dismisses
/// after 2.5s, or on tap. Shows a gold double frame, faint constellations,
/// scattered sparkles, an aurora glow behind a floating compass medallion, the
/// "Lumina" wordmark, an ornamental rule, a tagline and a gold spinner.
class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4400),
  )..repeat(reverse: true);

  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), _dismiss);
  }

  void _dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    widget.onDone();
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    const ink = Color(0xFF5A3E22);

    return GestureDetector(
      onTap: _dismiss,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.36),
              radius: 1.1,
              colors: [Color(0xFFFBF4E2), Color(0xFFF1E6CB), Color(0xFFE9DBBC)],
              stops: [0, 0.68, 1],
            ),
          ),
          child: Stack(
            children: [
              // Faint gold constellations.
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _ConstellationPainter()),
                ),
              ),

              // Gold double inset frame.
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0x99B0904C), width: 1.5),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0x57B0904C), width: 1),
                    ),
                  ),
                ),
              ),

              // Scattered sparkles.
              const _Sparkle(top: 0.20, left: 0.48, size: 13),
              const _Sparkle(top: 0.31, left: 0.74, size: 10),
              const _Sparkle(top: 0.70, left: 0.20, size: 11),

              // Center content.
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Aurora glow + floating medallion.
                    SizedBox(
                      width: 220,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                            child: const _Aurora(),
                          ),
                          AnimatedBuilder(
                            animation: _float,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(0, -9 * math.sin(_float.value * math.pi)),
                              child: child,
                            ),
                            child: const CompassMedallion(size: 120),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      s.appName,
                      style: context.serif(
                        fontSize: 54,
                        fontWeight: FontWeight.w700,
                        color: ink,
                        letterSpacing: context.isArabic ? null : 0.5,
                        shadows: const [
                          Shadow(color: Color(0x66FFFFFF), offset: Offset(0, 2)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _OrnamentRule(),
                    const SizedBox(height: 12),
                    Text(
                      s.tagline.toUpperCase(),
                      style: context.sans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6E4E2A),
                        letterSpacing: context.eyebrowTracking(13),
                      ),
                    ),
                  ],
                ),
              ),

              // Gold spinner near the bottom.
              const Positioned(
                bottom: 52,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFFA4843E),
                      backgroundColor: Color(0x40B0904C),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Aurora extends StatelessWidget {
  const _Aurora();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 240,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.3, -0.2),
          radius: 1.1,
          colors: [Color(0x8CF09656), Color(0x00F09656)],
          stops: [0, 0.56],
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.45, 0.1),
                radius: 1.1,
                colors: [Color(0x807E5CD6), Color(0x007E5CD6)],
                stops: [0, 0.56],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.1, 0.55),
                radius: 1.1,
                colors: [Color(0x734676E4), Color(0x004676E4)],
                stops: [0, 0.56],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrnamentRule extends StatelessWidget {
  const _OrnamentRule();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0x00B0904C), Color(0xFFB0904C)]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 11),
          child: Text('✦', style: TextStyle(fontSize: 11, color: Color(0xFFA4843E))),
        ),
        Container(
          width: 60,
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFB0904C), Color(0x00B0904C)]),
          ),
        ),
      ],
    );
  }
}

class _Sparkle extends StatelessWidget {
  final double top;
  final double left;
  final double size;
  const _Sparkle({required this.top, required this.left, required this.size});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(left * 2 - 1, top * 2 - 1),
      child: Text(
        '✦',
        style: TextStyle(fontSize: size, color: const Color(0xB3C0A258)),
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  const _ConstellationPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x80B0904C);
    final dot = Paint()..color = const Color(0xB3B0904C);

    void constellation(List<Offset> points) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, line);
      for (final p in points) {
        canvas.drawCircle(p, 1.7, dot);
      }
    }

    final w = size.width, h = size.height;
    // Top-left group.
    constellation([
      Offset(w * 0.08, h * 0.16), Offset(w * 0.20, h * 0.10),
      Offset(w * 0.32, h * 0.14), Offset(w * 0.44, h * 0.08),
      Offset(w * 0.58, h * 0.13),
    ]);
    // Bottom-right group.
    constellation([
      Offset(w * 0.55, h * 0.80), Offset(w * 0.66, h * 0.86),
      Offset(w * 0.74, h * 0.78), Offset(w * 0.86, h * 0.84),
      Offset(w * 0.92, h * 0.74),
    ]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
