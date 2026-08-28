import 'package:ansim_talk/home_screen/detail_screens/chat_room_screen.dart';
import 'package:ansim_talk/login/login_screen.dart';
import 'package:ansim_talk/splash_screen.dart';
import 'package:ansim_talk/test_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //스낵바 관련 설정
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF629822), // 전역 배경색
          actionTextColor: Colors.white,      // 액션 버튼 색상
          contentTextStyle: TextStyle(
            color: Colors.white,             // 기본 텍스트 색상
            fontSize: 16,
          ),
          behavior: SnackBarBehavior.floating, // 둥근 띄움 형태
        ),
      ),
      home: ChatRoomScreen()
    );
  }
}