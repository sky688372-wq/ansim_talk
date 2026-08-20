import 'package:ansim_talk/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 1. 아이콘 찰진 스케일 애니메이션
  late Animation<double> _iconScaleAnimation;

  // 2. 텍스트 Slide & Opacity 애니메이션
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // 빠른 진행을 위해 총 실행 시간을 1800ms(1.8초)로 단축
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // [아이콘 구동] : 0% ~ 45% 만에 0.6으로 축소 후 튕기듯 1.2로 확대
    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.6)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 1.2)
            .chain(CurveTween(curve: Curves.elasticOut)), // 통통 튀는 찰진 느낌
        weight: 60,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55),
      ),
    );

    // [텍스트 Slide 구동] : Curves.easeOutBack 적용하여 찰지게 스탑
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.8, 0.0), // 더 왼쪽에서 빠르게 접근
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutBack),
      ),
    );

    // [텍스트 Opacity 구동] : 빠르게 선명해짐
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.70, curve: Curves.easeIn),
      ),
    );

    _startAnimationAndNavigate();
  }

  Future<void> _startAnimationAndNavigate() async {
    // 애니메이션 재생
    await _controller.forward();

    // 살짝 여운을 주고 이동 (200ms)
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. 통통 튕기는 찰진 ScaleTransition
            ScaleTransition(
              scale: _iconScaleAnimation,
              child: Image.asset(
                'assets/logo/app_icon.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.shield, size: 100, color: Colors.lightGreen),
              ),
            ),

            const SizedBox(height: 24),

            // 2. 탁 치듯 바운스하며 맞춰지는 텍스트 영역
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textOpacityAnimation,
                child: Column(
                  children: [
                    const Text(
                      "안심톡",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '보이스 피싱 안심 메신저',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.7),
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