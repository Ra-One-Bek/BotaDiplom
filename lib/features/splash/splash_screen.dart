import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:career_guidance_app/app/router.dart';
import 'package:career_guidance_app/features/auth/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final AuthController _authController = AuthController();

  double _progress = 0;
  Timer? _timer;

  late final AnimationController _backgroundController;
  late final AnimationController _fadeController;
  late final AnimationController _iconBounceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _iconDropAnimation;
  late final Animation<double> _iconScaleAnimation;
  late final Animation<double> _titleSlideAnimation;

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _iconBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _iconDropAnimation = Tween<double>(begin: -90, end: 0).animate(
      CurvedAnimation(
        parent: _iconBounceController,
        curve: const _BallBounceCurve(),
      ),
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.88, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.06, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
    ]).animate(_iconBounceController);

    _titleSlideAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();
    _iconBounceController.forward();

    _startLoading();
  }

  Future<void> _startLoading() async {
    await _authController.loadSession();

    _timer = Timer.periodic(const Duration(milliseconds: 24), (timer) {
      if (!mounted) return;

      setState(() {
        _progress += 0.018;
        if (_progress > 1) {
          _progress = 1;
        }
      });

      if (_progress >= 1) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 280), _goNext);
      }
    });
  }

  void _goNext() {
    if (!mounted) return;

    final hasSession = _authController.accessToken != null &&
        _authController.currentUserId != null;

    Navigator.pushReplacementNamed(
      context,
      hasSession ? AppRouter.main : AppRouter.auth,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _backgroundController.dispose();
    _fadeController.dispose();
    _iconBounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = (_progress * 100).toInt();

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _fadeController,
          _iconBounceController,
        ]),
        builder: (context, _) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF8F5FF),
                  Color(0xFFEDE7FF),
                  Color(0xFFE4DEFF),
                  Color(0xFFF9F8FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                _GalaxyBackground(progress: _backgroundController.value),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 26,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          const Spacer(),
                          Transform.translate(
                            offset: Offset(0, _iconDropAnimation.value),
                            child: Transform.scale(
                              scale: _iconScaleAnimation.value,
                              child: _SplashOrbIcon(
                                shimmer: _backgroundController.value,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Transform.translate(
                            offset: Offset(0, _titleSlideAnimation.value),
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFF5C4BFF),
                                        Color(0xFF8B5CF6),
                                        Color(0xFF9D4EDD),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    'Proffy',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Профориентация нового поколения',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: const Color(0xFF5F5A7A)
                                        .withOpacity(0.92),
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          _GlassProgressCard(
                            progress: _progress,
                            percent: percent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SplashOrbIcon extends StatelessWidget {
  final double shimmer;

  const _SplashOrbIcon({
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    final pulse = 0.5 + 0.5 * math.sin(shimmer * math.pi * 2);

    return Container(
      width: 126,
      height: 126,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7C6CFF),
            Color(0xFF9B7CFF),
            Color(0xFFB79CFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8D74FF).withOpacity(0.22 + pulse * 0.10),
            blurRadius: 34,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.16),
            border: Border.all(
              color: Colors.white.withOpacity(0.30),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 20,
                left: 24,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              ),
              const Icon(
                Icons.auto_awesome_rounded,
                size: 52,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassProgressCard extends StatelessWidget {
  final double progress;
  final int percent;

  const _GlassProgressCard({
    required this.progress,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.58),
        border: Border.all(
          color: Colors.white.withOpacity(0.72),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8D74FF).withOpacity(0.10),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: const Color(0xFFE8E1FF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF7B61FF),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Загрузка профиля',
                style: TextStyle(
                  color: Color(0xFF554F73),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: Color(0xFF554F73),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GalaxyBackground extends StatelessWidget {
  final double progress;

  const _GalaxyBackground({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -90 + math.sin(progress * math.pi * 2) * 18,
          left: -50,
          child: _BlurOrb(
            size: 250,
            colors: const [
              Color(0x66FFFFFF),
              Color(0x339C88FF),
            ],
          ),
        ),
        Positioned(
          top: 120,
          right: -60 + math.cos(progress * math.pi * 2) * 20,
          child: _BlurOrb(
            size: 220,
            colors: const [
              Color(0x55BFA8FF),
              Color(0x22FFFFFF),
            ],
          ),
        ),
        Positioned(
          bottom: -70,
          left: 40 + math.sin(progress * math.pi * 2 + 1.2) * 16,
          child: _BlurOrb(
            size: 260,
            colors: const [
              Color(0x44D7CCFF),
              Color(0x22FFFFFF),
            ],
          ),
        ),
        Positioned(
          bottom: 110,
          right: 24 + math.cos(progress * math.pi * 2 + 0.8) * 10,
          child: Transform.rotate(
            angle: progress * math.pi * 2 * 0.15,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: const Color(0x33A38CFF),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
        ...List.generate(24, (index) {
          final seed = index / 24;
          final x = (seed * 320) + math.sin(progress * math.pi * 2 + seed * 7) * 18;
          final y =
              (seed * 700) % 760 + math.cos(progress * math.pi * 2 + seed * 9) * 12;
          final size = 2.0 + (index % 3);
          final opacity =
              0.20 + ((math.sin(progress * math.pi * 2 + seed * 10) + 1) / 2) * 0.35;

          return Positioned(
            left: x,
            top: y,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(opacity),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB39DFF).withOpacity(opacity * 0.7),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const _BlurOrb({
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: colors,
          ),
        ),
      ),
    );
  }
}

class _BallBounceCurve extends Curve {
  const _BallBounceCurve();

  @override
  double transform(double t) {
    if (t < 0.55) {
      return Curves.easeIn.transform(t / 0.55);
    } else if (t < 0.78) {
      final local = (t - 0.55) / 0.23;
      return 1.0 - math.sin(local * math.pi) * 0.16;
    } else if (t < 0.92) {
      final local = (t - 0.78) / 0.14;
      return 1.0 - math.sin(local * math.pi) * 0.07;
    } else {
      final local = (t - 0.92) / 0.08;
      return 1.0 - math.sin(local * math.pi) * 0.025;
    }
  }
}