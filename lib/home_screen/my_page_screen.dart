import 'package:ansim_talk/home_screen/detail_screens/faq_screen.dart';

import 'package:ansim_talk/home_screen/detail_screens/notification_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/notification_settings_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/user_info_setting_screen.dart';
import 'package:ansim_talk/login/login_screen.dart';
import 'package:ansim_talk/user_model/user_session.dart';
import 'package:flutter/material.dart';

import '../user_model/protection_mode_store.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool _isProtectionModeOn = true;

  @override
  void initState() {
    super.initState();
    _loadProtectionMode();
  }

  Future<void> _loadProtectionMode() async {
    await ProtectionModeStore.instance.loadOnce();

    if (!mounted) return;
    setState(() {
      _isProtectionModeOn = ProtectionModeStore.instance.enabled;
    });
  }

  Future<void> _saveProtectionMode(bool value) async {
    await ProtectionModeStore.instance.setEnabled(value);
  }

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
        // 다음 로그인 전에 이전 계정의 토큰과 사용자 정보를 비웁니다.
        UserSession().clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      }
    });
  }



  // 주요 사용 색깔들 모음
  static const Color brandGreen = Color(0xFF639922);
  static const Color brandGreenLight = Color(0xFFEAF3DE);
  static const Color brandGreenDark = Color(0xFF27500A);
  static const Color brandGreenText = Color(0xFF3B6D11);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFF7F9F5)),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 12),
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
      ),
    );
  }

  // UserSession에 저장된 이름과 프로필 이미지만 표시하는 상단 카드입니다.
  Widget _buildProfileHeader() {
    final session = UserSession();
    final userName = session.name.trim().isEmpty ? '사용자' : session.name.trim();
    final profileImage = session.profileImage.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF4B791C),
              Color(0xFF639922),
              Color(0xFF7EAC3B),
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: brandGreen.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -42,
                right: -20,
                child: Container(
                  width: 116,
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                bottom: -34,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 13,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _buildProfileAvatar(profileImage, userName),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 34,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String profileImage, String userName) {
    final initial = userName.isNotEmpty ? userName.substring(0, 1) : '?';

    if (profileImage.isEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundColor: brandGreenLight,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: brandGreenDark,
          ),
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        _resolveProfileImageUrl(profileImage),
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: 28,
          backgroundColor: brandGreenLight,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: brandGreenDark,
            ),
          ),
        ),
      ),
    );
  }

  String _resolveProfileImageUrl(String profileImage) {
    final imageUri = Uri.tryParse(profileImage);
    if (imageUri?.hasScheme ?? false) return profileImage;

    return profileImage.startsWith('/')
        ? 'http://192.168.40.175:8000$profileImage'
        : 'http://192.168.40.175:8000/$profileImage';
  }

  // 섹션 구분 라벨 ("보안", "계정", "정보")
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 20, 8),
      child: Row(
        children: <Widget>[
          Container(
            width: 4,
            height: 14,
            decoration: BoxDecoration(
              color: brandGreen,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // 보이스피싱 방지 모드 토글 카드 (기존 토글 로직 유지)
  Widget _buildProtectionModeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFFF2F8E9), Color(0xFFE5F1D5)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFCFE2B5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: brandGreen.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.shield_outlined, size: 24, color: brandGreenDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '보이스피싱 방지 모드',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: brandGreenDark,
                    ),
                  ),
                  const SizedBox(height: 3),
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
                _saveProtectionMode(value);
              },

            ),
          ],
        ),
      ),
    );
  }

  // 일반 메뉴 항목 (기존 onTap 동작은 그대로 유지)
  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 7),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFEDF0E9)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brandGreenLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 19, color: brandGreenDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
              ],
            ),
          ),
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
