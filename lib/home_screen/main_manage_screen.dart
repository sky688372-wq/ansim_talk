import 'package:ansim_talk/home_screen/chat_list_screen.dart';
import 'package:ansim_talk/home_screen/my_page_screen.dart';
import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('커뮤니티 화면'),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('검사 기록 화면'),
    );
  }
}

class MainManageScreen extends StatefulWidget {
  const MainManageScreen({super.key});

  @override
  State<MainManageScreen> createState() => _MainManageScreenState();
}

class _MainManageScreenState extends State<MainManageScreen> {
  // 현재 선택된 화면 번호
  int _currentIndex = 0;

  static const Color brandGreen = Color(0xFF639922);

  // 화면 순서
  final List<Widget> _screens = const [
    ChatListScreen(),   // 0
    CommunityScreen(),  // 1
    HistoryScreen(),    // 2
    MyPageScreen(),     // 3
  ];

  // 바텀 네비게이션 탭을 누르면 번호 변경
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // 떠 있는 형태의 바텀 네비게이션 바
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(35 ),
          child: BottomNavigationBar(
            // 현재 선택된 번호
            currentIndex: _currentIndex,

            // 탭을 누르면 해당 번호로 변경
            onTap: _onTabTapped,

            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,

            selectedItemColor: brandGreen,
            unselectedItemColor: Colors.grey,

            selectedFontSize: 13,
            unselectedFontSize: 13,

            items: const [
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
        ),
      ),
    );
  }
}