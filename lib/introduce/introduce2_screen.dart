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
            "대화하듯 물어보면,\n안심톡이 확인해드려요",
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
            '의심되는 문자를 채팅창에 붙여넣기만 하세요.\nAI가 꼼꼼히 살펴봐 드릴게요.',
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
