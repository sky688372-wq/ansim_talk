import 'package:flutter/material.dart';

class Introduce2Screen extends StatefulWidget {
  const Introduce2Screen({super.key});

  @override
  State<Introduce2Screen> createState() => _Introduce2ScreenState();
}

class _Introduce2ScreenState extends State<Introduce2Screen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/intro2.png',
            width: double.infinity,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 32),

          //제목 부분
          Text(
            "위험한 순간,\nAI가 먼저 알려드려요",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF27500A), // 안심톡 브랜드 초록(진한 톤)
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            '대화 속 의심스러운 신호를 AI가 분석해\n위험한 상황을 미리 예방할 수 있도록 도와드려요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
