import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/theme/lumina_context.dart';
import '../../../core/widgets/book_page_frame.dart';
import '../../../core/widgets/lumina_primary_button.dart';
import '../widgets/onboarding_art.dart';

/// Three-slide onboarding (first launch): a floating illustration over a soft
/// aurora glow, a serif title + body, a Skip affordance, animated progress dots,
/// and the gold CTA ("Next" → "Get started"). [onDone] fires on Skip or after
/// the last slide → the app advances to Login.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;
  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pager = PageController();
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4400),
  )..repeat(reverse: true);

  int _index = 0;

  @override
  void dispose() {
    _pager.dispose();
    _float.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < 2) {
      _pager.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    } else {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.strings;
    final tokens = context.lumina;
    final slides = <_Slide>[
      _Slide(0, s.onbTitle1, s.onbBody1, s.next),
      _Slide(1, s.onbTitle2, s.onbBody2, s.next),
      _Slide(2, s.onbTitle3, s.onbBody3, s.getStarted),
    ];

    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: BookPageFrame(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 22, 30, 30),
              child: Column(
                children: [
                  // Skip (hidden on the last slide).
                  SizedBox(
                    height: 26,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AnimatedOpacity(
                        opacity: _index < 2 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: TextButton(
                          onPressed: _index < 2 ? widget.onDone : null,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            s.skip,
                            style: context.sans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: tokens.soft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pager,
                      itemCount: slides.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (_, i) => _SlideView(
                        slide: slides[i],
                        float: _float,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Dots(count: slides.length, index: _index),
                  const SizedBox(height: 22),
                  LuminaPrimaryButton(label: slides[_index].cta, onPressed: _next),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Slide {
  final int index;
  final String title;
  final String body;
  final String cta;
  const _Slide(this.index, this.title, this.body, this.cta);
}

class _SlideView extends StatelessWidget {
  final _Slide slide;
  final Animation<double> float;
  const _SlideView({required this.slide, required this.float});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 230,
          height: 230,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const _AuroraGlow(),
              AnimatedBuilder(
                animation: float,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, -9 * math.sin(float.value * math.pi)),
                  child: child,
                ),
                child: OnboardingArt(index: slide.index),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: context.serif(
            fontSize: 33,
            fontWeight: FontWeight.w600,
            color: tokens.ink,
            height: context.isArabic ? 1.35 : 1.08,
            letterSpacing: context.isArabic ? null : -0.3,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            slide.body,
            textAlign: TextAlign.center,
            style: context.sans(
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: tokens.soft,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

/// The soft, blurred multi-color glow behind the floating art.
class _AuroraGlow extends StatelessWidget {
  const _AuroraGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.6,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
          child: Container(
            width: 210,
            height: 210,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: Alignment(-0.2, -0.2),
                radius: 0.9,
                colors: [Color(0x80F09656), Color(0x00F09656)],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(0.4, 0.3),
                  radius: 0.9,
                  colors: [Color(0x737E5CD6), Color(0x007E5CD6)],
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment(0.1, 0.6),
                    radius: 0.9,
                    colors: [Color(0x664676E4), Color(0x004676E4)],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Progress dots — the active dot stretches to a gold pill.
class _Dots extends StatelessWidget {
  final int count;
  final int index;
  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    final tokens = context.lumina;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 26 : 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: i == index
                  ? tokens.accent
                  : tokens.faint.withValues(alpha: 0.5),
            ),
          ),
      ],
    );
  }
}
