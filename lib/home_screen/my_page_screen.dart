import 'package:ansim_talk/home_screen/detail_screens/faq_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/my_info_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/notification_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/notification_settings_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/user_info_setting_screen.dart';
import 'package:ansim_talk/login/login_screen.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {

  void _tryLogout() {
    showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 로그아웃 아이콘
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 36,
                  color: Colors.red[600],
                ),
              ),

              const SizedBox(height: 20),

              // 제목
              const Text(
                '로그아웃하시겠습니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              // 설명
              Text(
                '로그아웃하면 현재 계정에서 나가게 됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 24),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((result) {
      if (result == true) {
        //실제로는 전시회에서의 시연을 위해서 로컬에 로그인 저장 로직을 실행 안할거임
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        //로그아웃 알림 띄우기
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
            "로그아웃 되었습니다.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ))
        );
      }
    });
  }

  //나중에 이 트리거를 이용해서 AI모드를 적용할지 안할지 등을 만들면 됨
  bool _isProtectionModeOn = true; // 보이스피싱 방지 모드 상태

  // 주요 사용 색깔들 모음
  static const Color brandGreen = Color(0xFF639922);
  static const Color brandGreenLight = Color(0xFFEAF3DE);
  static const Color brandGreenDark = Color(0xFF27500A);
  static const Color brandGreenText = Color(0xFF3B6D11);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //상단 계정 헤더
          _buildProfileHeader(),
          _buildSectionLabel('보안'),
          //보이스피싱 방지 모드 트리거 카드
          _buildProtectionModeCard(),

          //여기서부터 설정 목록들
          _buildSectionLabel('계정'),
          _buildMenuTile(
            icon: Icons.notifications_outlined,
            label: '알림 설정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
            },
          ),
          _buildMenuTile(
            icon: Icons.person_outline,
            label: '개인정보 수정',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoSettingScreen()));
            },
          ),
          _buildSectionLabel('정보'),
          _buildMenuTile(
            icon: Icons.campaign_outlined,
            label: '공지사항',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
            },
          ),
          _buildMenuTile(
            icon: Icons.help_outline,
            label: '자주 묻는 질문',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FaqScreen()));
            },
          ),
          _buildMenuTile(
            icon: Icons.description_outlined,
            label: '이용약관 및 개인정보처리방침',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          _buildLogoutButton(),
          const SizedBox(height: 12),
          _buildVersionText(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // 상단 프로필 영역
  Widget _buildProfileHeader() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyInfoScreen()));
      },

      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: brandGreenLight,
              child: Text(
                'T',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: brandGreenDark,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Test',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '010-1234-5678',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  // 섹션 구분 라벨 ("보안", "계정", "정보")
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // 보이스피싱 방지 모드 토글 카드 (가장 강조되는 요소)
  Widget _buildProtectionModeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: brandGreenLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, size: 26, color: brandGreenDark),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '보이스피싱 방지 모드',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: brandGreenDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '채팅방 진입 시 자동으로 분석해요',
                    style: TextStyle(fontSize: 13, color: brandGreenText),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isProtectionModeOn,
              activeColor: Colors.white,
              activeTrackColor: brandGreen,
              onChanged: (value) {
                setState(() {
                  _isProtectionModeOn = value;
                });
                // TODO: 실제 방지 모드 상태를 서버/로컬 저장소에 반영하는 로직 추가
              },
            ),
          ],
        ),
      ),
    );
  }

  // 일반 메뉴 항목 (아이콘 + 라벨 + 화살표)
  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // 로그아웃 버튼 - 위험 액션이라 빨간 배경으로 다른 메뉴와 명확히 구분
  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          // TODO: 로그아웃 로직 (로컬 세션 삭제 후 로그인 화면으로 이동 )
          _tryLogout();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFCEBEB),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            '로그아웃',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA32D2D),
            ),
          ),
        ),
      ),
    );
  }

  // 하단 앱 버전 정보
  Widget _buildVersionText() {
    return Center(
      child: Text(
        '안심톡 v1.0.0',
        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
      ),
    );
  }
}
