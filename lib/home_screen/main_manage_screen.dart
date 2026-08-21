import 'package:ansim_talk/home_screen/chat_list_screen.dart';
import 'package:flutter/material.dart';

// 각 탭에 들어갈 화면들 - 아직 내용은 없고 자리만 잡아둔 상태 (추후 하나씩 완성)
// 실제 완성되면 각자 파일로 분리해서 import 해오면 됨
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('홈 화면'));
}


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('커뮤니티 화면'));
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('검사 기록 화면'));
}

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('마이페이지 화면'));
}

// 탭 5개(홈/채팅/커뮤니티/검사기록/마이페이지)를 관리하는 컨테이너
class MainManageScreen extends StatefulWidget {
  const MainManageScreen({super.key});

  @override
  State<MainManageScreen> createState() => _MainManageScreenState();
}

class _MainManageScreenState extends State<MainManageScreen> {

  int _currentIndex = 0; // 현재 선택된 탭 인덱스 (0-based)

  static const Color brandGreen = Color(0xFF639922); // 안심톡 브랜드 초록

  // 탭 순서: 0 홈 / 1 채팅 / 2 커뮤니티 / 3 검사 기록 / 4 마이페이지
  final List<Widget> _screens = const [
    HomeScreen(),
    ChatListScreen(),
    CommunityScreen(),
    HistoryScreen(),
    MyPageScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // IndexedStack을 쓰면 탭을 바꿔도 각 화면의 상태(스크롤 위치 등)가 유지됨
        index: _currentIndex,
        children: _screens,
      ),

      //네비게이터 바
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // 탭 5개 이상일 때 라벨이 안 사라지게 고정하는 설정
        selectedItemColor: brandGreen,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: '검사 기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}