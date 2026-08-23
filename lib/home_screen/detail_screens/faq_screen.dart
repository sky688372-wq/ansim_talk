import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 자주 묻는 질문 페이지
// MDP 발표회에서 작품 설명에 필요한 내용을 Notion으로 정리하고,
// 버튼을 눌러 해당 Notion 페이지로 이동하도록 구성

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // 실제 Notion 페이지 주소
  final Uri _notionUrl = Uri.parse(
    'https://app.notion.com/p/3c2868e9b5de80579a81d97f99960171?source=copy_link',
  );

  // Notion 페이지 열기
  Future<void> _openNotion() async {
    final success = await launchUrl(
      _notionUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notion 페이지를 열 수 없습니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF6),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF8FAF6),
        elevation: 0,
        title: const Text(
          '자주 묻는 질문',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // 상단 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF3DE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                size: 42,
                color: Color(0xFF639922),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              '안심톡이 궁금하신가요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              '작품의 기획 의도와 주요 기능,\n'
                  '발표회에서 자주 나오는 질문을 정리해 두었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 36),

            // Notion 안내 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '상세 질문 및 답변',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Notion에서 전체 내용을 확인할 수 있어요.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Notion 이동 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _openNotion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF639922),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Notion에서 확인하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Text(
              '안심톡 발표 및 작품 설명 자료',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}