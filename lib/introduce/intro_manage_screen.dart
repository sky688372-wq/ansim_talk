import 'package:ansim_talk/home_screen/chat_list_screen.dart';
import 'package:ansim_talk/introduce/introduce1_screen.dart';
import 'package:ansim_talk/introduce/introduce2_screen.dart';
import 'package:ansim_talk/introduce/introduce3_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroManageScreen extends StatefulWidget {
  const IntroManageScreen({super.key});

  @override
  State<IntroManageScreen> createState() => _IntroManageScreenState();
}

class _IntroManageScreenState extends State<IntroManageScreen> {

  // 인디케이터 패키지(스무스 인디케이터)를 불러와서 인디케이터 + 페이지 뷰를 이용해서 소개 화면을 만들 생각임

  final PageController _pageCtrl = PageController(); //페이지 관리 컨트롤러

  int index = 1; // 화면에 표시되는 페이지 번호 (1-based)

  static const int totalPage = 3; // 총 페이지 수

  static const Color brandGreen = Color(0xFF639922); // 안심톡 브랜드 초록

  @override
  void dispose() {
    _pageCtrl.dispose(); // 컨트롤러는 화면 사라질 때 꼭 해제
    super.dispose();
  }

  void _goNext() {
    if (index < totalPage) {
      // 마지막 페이지가 아니면 다음 페이지로 애니메이션 이동
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 마지막 페이지에서 버튼 눌렀을 때 동작
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatListScreen()));
    }
  }

  void _goBack() {
    if (index > 1) {
      // 첫 페이지가 아니면 이전 페이지로 애니메이션 이동
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 첫 페이지에서 뒤로가기 누르면 화면 자체를 닫음 (이전 화면으로)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              // 상단 뒤로가기 + 남은 페이지 표시와 넘어가기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (index > 1) // 첫 페이지(1)에서는 뒤로가기 버튼 자체를 숨김
                        IconButton(
                          onPressed: _goBack, // 이전 페이지로 이동
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          color: Colors.black,
                        ),

                      Text(
                        index.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                      Text(
                        "/$totalPage",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),

                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatListScreen()));
                      },
                      child: Text(
                        "넘어갈래요",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      )
                  )
                ],
              ),

              SizedBox(height: 20,),

              Expanded(
                child: PageView( //기본적으로 스크롤도 가능하도록 하면 될 긋
                  controller: _pageCtrl,
                  onPageChanged: (page) {
                    // PageView는 0-based라서 화면 표시용 index는 +1 해서 저장
                    setState(() {
                      index = page + 1;
                    });
                  },
                  children: const [
                    // 1번째 페이지
                    Introduce1Screen(),

                    // 2번째 페이지
                    Introduce2Screen(),

                    // 3번째 페이지
                    Introduce3Screen()
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 하단 페이지 인디케이터
              SmoothPageIndicator(
                controller: _pageCtrl,
                count: totalPage,
                effect: const WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: brandGreen,
                  dotColor: Color(0xFFE0E0E0),
                ),
              ),

              const SizedBox(height: 24),

              // 다음 페이지로 넘어가는 버튼 (눈에 띄게 ElevatedButton으로)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _goNext, // 다음 페이지로 이동 (마지막이면 TODO 로직 실행)
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    index < totalPage ? "다음" : "시작하기", // 마지막 페이지에서는 문구 변경
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}