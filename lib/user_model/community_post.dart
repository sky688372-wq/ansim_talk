// 커뮤니티 화면에 보여줄 보이스피싱 예방 콘텐츠
// 외부 API 없이 고정 데이터로 관리 (발표/시연 시 네트워크 문제로 화면이 비는 것을 방지)
class CommunityPost {
  final String title;
  final String description;
  final String category;
  final String imageAsset; // assets/community/ 폴더의 로컬 이미지 경로
  final String? videoUrl;  // 탭하면 열리는 관련 영상/정보 링크 (선택)

  const CommunityPost({
    required this.title,
    required this.description,
    required this.category,
    required this.imageAsset,
    this.videoUrl,
  });
}

