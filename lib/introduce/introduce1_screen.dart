import 'package:flutter/material.dart';

class Introduce1Screen extends StatefulWidget {
  const Introduce1Screen({super.key});

  @override
  State<Introduce1Screen> createState() => _Introduce1ScreenState();
}

class _Introduce1ScreenState extends State<Introduce1Screen> {

  //사용자에게 문자 메세지 사용 어려움에 대한 공감을 이끌어내는 부분

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/intro1_chat.png',
            width: double.infinity,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 32),

          //제목 부분
          Text(
            "문자 메시지, 어렵고\n헷갈리셨나요?",
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
            '낯선 문자 하나에도\n마음이 철렁했던 적, 있으실 거예요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}