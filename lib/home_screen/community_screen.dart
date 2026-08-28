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
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFF7F9F5)),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _buildFeaturedPost(communityPosts.first),
            ),
            _buildFeedHeader(communityPosts.length - 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: communityPosts
                      .skip(1)
                      .map(_buildNewsListItem)
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: brandGreen,
              borderRadius: BorderRadius.circular(14),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: brandGreen.withValues(alpha: 0.24),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.newspaper_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '안심 뉴스',
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '보이스피싱 예방 캠페인',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPost(CommunityPost post) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: post.videoUrl == null ? null : () => _openLink(post.videoUrl!),
        child: SizedBox(
          height: 238,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildPostImage(post),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, Color(0xD9000000)],
                    stops: <double>[0.32, 1],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: _buildTag(post.category, onDark: true),
              ),
              if (post.videoUrl != null)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  ),
                ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Text(
                  post.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedHeader(int articleCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 10),
      child: Row(
        children: <Widget>[
          const Text(
            '최신 소식',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Text(
            '$articleCount건',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsListItem(CommunityPost post) {
    return InkWell(
      onTap: post.videoUrl == null ? null : () => _openLink(post.videoUrl!),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F2ED))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 104,
                height: 92,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildPostImage(post),
                    if (post.videoUrl != null)
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: SizedBox(
                height: 92,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTag(post.category),
                    const SizedBox(height: 7),
                    Expanded(
                      child: Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.25,
                        ),
                      ),
                    ),
                    Text(
                      '예방 정보 영상',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage(CommunityPost post) {
    return Image.network(
      post.imageAsset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('[CommunityScreen] 이미지 로딩 실패: ${post.imageAsset}');
        print('[CommunityScreen] 이미지 오류: $error');
        return _buildImageFallback();
      },
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: brandGreenLight,
      child: const Center(
        child: Icon(Icons.campaign_outlined, color: brandGreen, size: 32),
      ),
    );
  }

  Widget _buildTag(String text, {bool onDark = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.9) : brandGreenLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: brandGreenDark,
          fontWeight: FontWeight.w700,
        ),
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