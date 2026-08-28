import 'package:ansim_talk/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Color _brandGreen = Color(0xFF639922);
  static const Color _brandGreenDark = Color(0xFF27500A);
  static const Color _brandGreenLight = Color(0xFFEAF3DE);

  late final AnimationController _introController;
  late final AnimationController _ambientController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoTurn;
  late final Animation<double> _haloScale;
  late final Animation<double> _haloOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2450),
    );
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.04, 0.27, curve: Curves.easeOut),
    );
    _logoScale = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.64, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 72,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 28,
      ),
    ]).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.05, 0.47)),
    );
    _logoTurn = Tween<double>(begin: -0.045, end: 0).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.05, 0.40, curve: Curves.easeOutCubic)),
    );
    _haloScale = Tween<double>(begin: 0.72, end: 1.56).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.04, 0.53, curve: Curves.easeOut)),
    );
    _haloOpacity = Tween<double>(begin: 0.42, end: 0.0).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.18, 0.58, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.26), end: Offset.zero).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.34, 0.66, curve: Curves.easeOutCubic)),
    );
    _titleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.34, 0.61, curve: Curves.easeOut),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.56, 0.79, curve: Curves.easeIn),
    );
    _progressValue = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _introController, curve: const Interval(0.61, 0.94, curve: Curves.easeInOutCubic)),
    );

    _startAnimationAndNavigate();
  }

  Future<void> _startAnimationAndNavigate() async {
    await _introController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 180));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 330),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[_introController, _ambientController]),
        builder: (context, _) {
          final floatingOffset = (_ambientController.value - 0.5) * 28;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Color(0xFFF7FBF1), Color(0xFFE5F0D6), Color(0xFFD5E7BD)],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -80 + floatingOffset,
                  right: -64,
                  child: _buildBackgroundOrb(220, _brandGreen.withValues(alpha: 0.10)),
                ),
                Positioned(
                  bottom: -92 - floatingOffset,
                  left: -68,
                  child: _buildBackgroundOrb(230, Colors.white.withValues(alpha: 0.44)),
                ),
                Positioned(
                  top: 152 - floatingOffset,
                  left: 26,
                  child: _buildBackgroundOrb(36, _brandGreen.withValues(alpha: 0.12)),
                ),
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildLogoAnimation(),
                          const SizedBox(height: 28),
                          SlideTransition(
                            position: _titleSlide,
                            child: FadeTransition(
                              opacity: _titleOpacity,
                              child: const Text(
                                '안심톡',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.2,
                                  color: _brandGreenDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FadeTransition(
                            opacity: _subtitleOpacity,
                            child: Text(
                              '보이스피싱 안심 메신저',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: _brandGreenDark.withValues(alpha: 0.76),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          FadeTransition(
                            opacity: _subtitleOpacity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '안전한 대화를 준비하고 있어요',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14, color: _brandGreenDark.withValues(alpha: 0.68)),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 118,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: LinearProgressIndicator(
                                      value: _progressValue.value,
                                      minHeight: 5,
                                      backgroundColor: Colors.white.withValues(alpha: 0.66),
                                      valueColor: const AlwaysStoppedAnimation<Color>(_brandGreen),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildLogoAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Transform.scale(
          scale: _haloScale.value,
          child: Opacity(
            opacity: _haloOpacity.value,
            child: Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _brandGreen.withValues(alpha: 0.42), width: 2),
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _logoOpacity,
          child: ScaleTransition(
            scale: _logoScale,
            child: RotationTransition(
              turns: _logoTurn,
              child: Container(
                width: 118,
                height: 118,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: _brandGreen,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: _brandGreen.withValues(alpha: 0.30),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo/app_icon.png',
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield_rounded,
                    size: 68,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
