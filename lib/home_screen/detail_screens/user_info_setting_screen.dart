import 'package:flutter/material.dart';

class UserInfoSettingScreen extends StatefulWidget {
  const UserInfoSettingScreen({super.key});

  @override
  State<UserInfoSettingScreen> createState() => _UserInfoSettingScreenState();
}

class _UserInfoSettingScreenState extends State<UserInfoSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            '개인정보 설정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 공지사항 아이콘
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.campaign_outlined,
                  size: 55,
                  color: Colors.blue[700],
                ),
              ),

              const SizedBox(height: 28),

              // 메인 문구
              const Text(
                "현재 개발중인 페이지",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // 보조 문구
              Text(
                "개발 중",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 30),

              // 안내 카드
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 24,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "개발중인 화면입니다.",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
