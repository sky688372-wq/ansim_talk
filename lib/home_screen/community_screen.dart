import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../secrets/public_ad_model.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  static const Color brandGreen = Color(0xFF639922);
  static const Color brandGreenLight = Color(0xFFEAF3DE);
  static const Color brandGreenDark = Color(0xFF27500A);

  late Future<List<PublicAdModel>> _adsFuture;

  @override
  void initState() {
    super.initState();
    _adsFuture = _loadAds();
  }

  Future<List<PublicAdModel>> _loadAds() async {
    final ads = await PublicAdModel.fetchAds(perPage: 30);
    // 보이스피싱/금융사기 관련만 우선 필터링
    final filtered = PublicAdModel.filterVoicePhishingRelated(ads);
    // 필터링 결과가 너무 적으면(예: 3개 미만) 전체 목록을 보여줌 (빈 화면 방지)
    return filtered.length >= 3 ? filtered : ads;
  }

  Future<void> _refresh() async {
    setState(() {
      _adsFuture = _loadAds();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: FutureBuilder<List<PublicAdModel>>(
              future: _adsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: brandGreen));
                }

                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                final ads = snapshot.data ?? [];
                if (ads.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  color: brandGreen,
                  onRefresh: _refresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(ads[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 게시물 카드 하나 (이미지 + 태그 + 제목 + 설명 + 영상 버튼)
  Widget _buildPostCard(PublicAdModel ad) {
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
          _buildImageArea(ad),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((ad.category ?? '').isNotEmpty || (ad.subject ?? '').isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: [
                      if ((ad.category ?? '').isNotEmpty) _buildTag(ad.category!),
                      if ((ad.subject ?? '').isNotEmpty) _buildTag(ad.subject!),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  ad.title ?? '제목 없음',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                if ((ad.description ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    ad.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
                  ),
                ],
                if ((ad.videoUrl ?? '').isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openLink(ad.videoUrl!),
                      icon: const Icon(Icons.play_circle_outline, size: 20, color: brandGreenDark),
                      label: const Text('영상 보기', style: TextStyle(color: brandGreenDark, fontWeight: FontWeight.w500)),
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

  // 카드 상단 이미지 영역. 유튜브 썸네일 → imageUrl → 폴백 아이콘 순서로 시도
  Widget _buildImageArea(PublicAdModel ad) {
    final thumbnailUrl = ad.youtubeThumbnailUrl ?? ad.imageUrl;
    final hasImage = thumbnailUrl != null && thumbnailUrl.isNotEmpty;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: hasImage
          ? Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(color: brandGreenLight);
        },
        errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
      )
          : _buildImageFallback(),
    );
  }

  Widget _buildImageFallback() {
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('아직 게시된 캠페인이 없어요', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text('데이터를 불러오지 못했어요', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _refresh,
            child: const Text('다시 시도', style: TextStyle(color: brandGreen)),
          ),
        ],
      ),
    );
  }
}