import 'package:ansim_talk/user_model/community_post.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const Color brandGreen = Color(0xFF639922);
  static const Color brandGreenLight = Color(0xFFEAF3DE);
  static const Color brandGreenDark = Color(0xFF27500A);

  @override
  Widget build(BuildContext context) {

    // TODO: imageAsset 경로에 실제 이미지를 준비해서 assets/community/ 폴더에 넣고
// pubspec.yaml의 assets 목록에도 등록해주세요.
    final List<CommunityPost> communityPosts = [
      const CommunityPost(
        title: '60대 이상만 노렸다…112 신고 전화도 가로챈 보이스피싱',
        description: '"중국에 거점을 두고 피해자 110여 명에게서  100억 원을 가로챈  보이스피싱 조직원들이  국내로 압송됐습니다. 60대 이상 고령층만 노렸는데, 의심을 품고 경찰에 건 신고 전화마저 가로채는  악성 앱을 깔아 피해자들을 감쪽같이 속였습니다.',
        category: '사칭',
        imageAsset: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDIzUIvkAEH0CUQkiIeTKwEADpTNEJ_h_ca67fpTKM9Q&s=10',
        videoUrl: 'https://www.google.com/goto?url=CAESYwHrOzAV6kHr-x0ec8W5ZZipU2qINz_sLe3lBTp3_CyMLBVxMlCVbQOqwweL0ijC7Sxe9P26sk3tjeXHWkw5bfsZOzh_TaRma_pdBNcBBqOIJ3N_-tftdqu6gx4lC_sFR9kslQ',
      ),
      const CommunityPost(
        title: '“카드 발급” 부터 ‘셀프 감금’까지 지시…조직적 보이스피싱 ',
        description: '보이스피싱 수법이 날로 교묘해지고 있습니다. 한 일당이 4단계에 걸쳐 역할을 나눠 피해자를 압박하며 돈을 뜯어냈습니다. 피해자를 2주 간 집에 고립시킨 뒤 외부의 도움도 철저히 차단했습니다. ',
        category: '사칭',
        imageAsset: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcLYQpuR8MuvcjkiKMHfbh9HFijXDF3U-j_Nfep4UyVw&s=10',
        videoUrl: 'https://www.youtube.com/watch?v=W3VU3Yf418s',
      ),
      const CommunityPost(
        title: '"엄마 나 큰일났어!" \'아들\'의 전화‥신종 보이스피싱 포착',
        description: """이제 아예 가족과 똑같은 전화번호로 돈을 뜯어내는 신종 보이스피싱 수법이 등장했습니다.
지금까지는 모르는 번호로 온 전화를 받았다가 사칭에 넘어가는 식이었는데, 발신번호 조작까지 범죄가 진화한 겁니다.""",
        category: '가족 사칭',
        imageAsset: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRComaWGmg3yMxoTk40vJKYM9jxyK3Tr079vY558DjjJQ&s=10',
        videoUrl: 'https://www.youtube.com/watch?v=K2stba5XuO0',
      ),
      const CommunityPost(
        title: 'AI로 만든 가짜 아이 울음소리‥신종 보이스피싱 주의보 ',
        description: '최근 AI로 만든 아이의 가짜 울음소리를 들려주며 돈을 요구하는 신종 보이스피싱 수법이 기승을 부리고 있습니다. 전화상으로는 자녀의 울음소리인지 파악이 어려운 데다 비교적 적은 금액을 요구하다 보니 속아 넘어가기가 더욱 쉽다는 건데요.',
        category: '가족 사칭',
        imageAsset: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPtclcbgiruyEKIpDiGXmvaErBT7i6ezqDcm_1kDC2pg&s=10',
        videoUrl: 'https://www.youtube.com/watch?v=wZhXd22l3yU',
      ),
      const CommunityPost(
        title: '다행히 탈출했지만...이전과 달라진 보이스피싱범 통화 내용',
        description: '실제 경찰과 검찰 등 수사기관은 전화나 메신저로 수사하거나 이메일로 관련 서류를 보내지 않습니다. 또 출처 불명의 앱을 설치하게 하거나 조사 명목으로 혼자 숙박시설에 머물게 하는 일도 없고, 자산을 한 계좌에 모으라고 요구하지도 않습니다.',
        category: '사칭',
        imageAsset: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu2UQeR7WO203cgkCiSZBC67qZ01LlznIkCL-3g2rE-g&s=10',
        videoUrl: 'https://www.youtube.com/watch?v=jXJMbSM-6Z4',
      ),
      const CommunityPost(
        title: '셀프감금에 나체 사진..태국 거점 보이스피싱조직 검거',
        description: '검찰과 금감원을 사칭한 보이스피싱 사기로 60억 원 넘게 빼앗은 일당이 경찰에 붙잡혔습니다. 피해자들에게 이른바 셀프 감금 후 나체 사진까지 찍도록 한 걸로 파악됐습니다.',
        category: '사칭',
        imageAsset: 'https://i.ytimg.com/vi/REpozQU_lUA/mqdefault.jpg',
        videoUrl: 'https://www.youtube.com/watch?v=REpozQU_lUA',
      ),
    ];


    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '커뮤니티',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                Text(
                  '보이스피싱 예방 캠페인',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            // 고정 데이터라 네트워크 호출/로딩/에러 처리 자체가 필요 없음
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: communityPosts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(communityPosts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 게시물 카드 하나
  Widget _buildPostCard(CommunityPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageArea(post),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTag(post.category),
                const SizedBox(height: 8),
                Text(
                  post.title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                ),
                if (post.videoUrl != null) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openLink(post.videoUrl!),
                      icon: const Icon(Icons.play_circle_outline, size: 20, color: brandGreenDark),
                      label: const Text('자세히 보기', style: TextStyle(color: brandGreenDark, fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: brandGreen),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 카드 상단 이미지 - 로컬 assets 이미지 사용 (네트워크 불필요) todo 현재 이미지 로딩 안되는 현상 고치기
  Widget _buildImageArea(CommunityPost post) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.asset(
        post.imageAsset,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로딩 실패');
          print('URL: ${post.imageAsset}');
          print('ERROR: $error');
          print('STACK: $stackTrace');

          return _buildImageFallback();
        },
      ),
    );
  }

  Widget _buildImageFallback() {
    print("이미지 로딩 안됨");
    return Container(
      color: brandGreenLight,
      child: const Center(
        child: Icon(Icons.campaign_outlined, color: brandGreen, size: 36),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: brandGreenLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: brandGreenDark, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}