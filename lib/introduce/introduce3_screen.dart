import 'package:flutter/material.dart';

class Introduce3Screen extends StatefulWidget {
  const Introduce3Screen({super.key});

  @override
  State<Introduce3Screen> createState() => _Introduce3ScreenState();
}

class _Introduce3ScreenState extends State<Introduce3Screen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/intro3.png',
            width: double.infinity,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 32),

          //제목 부분
          Text(
            "위험하면, QR 하나로 든든하게 지켜드려요",
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
            '위험한 문자로 확인되면 QR을 만들어드려요.\nATM에 보여주시면 출금을 막아드립니다.',
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
