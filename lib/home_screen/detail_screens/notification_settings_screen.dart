import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {

  // 알림 설정 상태
  bool allNotification = true;
  bool phishingNotification = true;
  bool counselorNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '알림 설정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 전체 알림
            _buildNotificationTile(
              title: '전체 알림',
              subtitle: '안심톡의 모든 알림을 받습니다.',
              value: allNotification,
              onChanged: (value) {
                setState(() {
                  allNotification = value;
                });
              },
            ),

            const SizedBox(height: 10),

            // 피싱 위험 알림
            _buildNotificationTile(
              title: '피싱 위험 알림',
              subtitle: '채팅에서 피싱 위험이 감지되면 알려줍니다.',
              value: phishingNotification,
              onChanged: (value) {
                setState(() {
                  phishingNotification = value;
                });
              },
            ),

            const SizedBox(height: 10),

            // 상담원 연결 알림
            _buildNotificationTile(
              title: '상담원 연결 알림',
              subtitle: '상담원 연결과 관련된 알림을 받습니다.',
              value: counselorNotification,
              onChanged: (value) {
                setState(() {
                  counselorNotification = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // 알림 설정 항목
  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          // 아이콘
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.blue[700],
            ),
          ),

          const SizedBox(width: 14),

          // 제목 + 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // 스위치
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}