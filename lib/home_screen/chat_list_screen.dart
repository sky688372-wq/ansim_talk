import 'package:flutter/material.dart';
import 'package:ansim_talk/user_model/user_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  //나중에 AI로 판단해서 의심이 간다면 !아이콘을 오른쪽 끝에 두면 될 듯함

  // 가짜 페이크 리스트 : 출처는 Unflash
  List<UserModel> usersData = [
    UserModel(
      name: '이서연',
      imgPath: 'assets/user/user1.jpg',
      introduce: '바다를 보며 힐링하는 것을 좋아하는 프리랜서 디자이너입니다. 탁 트인 바다 풍경을 사랑해요.',
    ),
    UserModel(
      name: '박지훈',
      imgPath: 'assets/user/user2.jpg',
      introduce: '주말마다 고궁 투어를 즐기는 역사 매니아입니다. 궁궐의 단청과 전통 한복의 아름다움을 좋아해요.',
    ),
    UserModel(
      name: '김도윤',
      imgPath: 'assets/user/user3.jpg',
      introduce: '서울의 도심 풍경과 전통 건축물을 넓은 화각으로 담아내는 풍경 사진작가입니다. 좋은 출사지 공유해요.',
    ),
    UserModel(
      name: '최은지',
      imgPath: 'assets/user/user4.jpg',
      introduce: '흑백 필름 카메라로 일상의 소박한 찰나를 기록합니다. 나무가 우거진 조용한 공원 산책을 좋아해요.',
    ),
    UserModel(
      name: '정수아',
      imgPath: 'assets/user/user5.jpg',
      introduce: '제주도 오름 등반과 트레킹을 사랑하는 여행가입니다. 맑은 하늘 아래 자연 속에서 걷는 게 제일 좋아요.',
    ),
    UserModel(
      name: '윤서준',
      imgPath: 'assets/user/user6.jpg',
      introduce: '노을 지는 바닷가를 홀로 거니는 석양 수집가입니다. 해질녘 황금빛 바다가 주는 평온함을 사랑해요.',
    ),
    UserModel(
      name: '임현우',
      imgPath: 'assets/user/user7.jpg',
      introduce: '고즈넉한 산사와 자연의 소리를 찾아다니는 템플스테이 매니아입니다. 마음의 휴식이 필요할 때 산을 찾아요.',
    ),
    UserModel(
      name: '한예진',
      imgPath: 'assets/user/user8.jpg',
      introduce: '반려견 몽이의 일상을 공유하는 4년 차 반려인 한예진입니다. 프사는 세상에서 제일 귀여운 우리 집 몽이에요.',
    ),
    UserModel(
      name: '김영수',
      imgPath: 'assets/user/user9.jpg',
      introduce: '시원한 물 한 잔, 막걸리 한 잔 나누며 사람 냄새 나는 이야기를 즐기는 정겨운 시골 마을 이장님입니다.',
    ),
    UserModel(
      name: '송채원',
      imgPath: 'assets/user/user10.jpg',
      introduce: '단아한 한복의 미를 널리 알리고 싶은 한복 모델이자 스냅 작가입니다. 전통 의상의 매력을 담는 작업을 해요.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          
          //개인채팅, 일반 채팅용 버튼(꾸미기 용)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //여기세 칩 박아두면 됨
              //리스트 빌더 형식으로 하면 될 듯함
            ],
          ),
          
          Expanded(
            child: ListView.builder( //기본적으로 스크롤 기능 존재함
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 11),
              itemCount: usersData.length,
              itemBuilder: (context, index) {
                final currentUser = usersData[index];
            
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // TODO: 디테일 스크린 이동 로직 작성 위치
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // 1. 프로필 사진 (원형 아바타)
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(30),
                            child: Image.asset(
                              currentUser.imgPath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
            
                          const SizedBox(width: 14),
            
                          // 2. 이름 및 간단 소개 (세로 배치)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentUser.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
            
                                //간단 소개 부분
                                Text(
                                  currentUser.introduce,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.3,
                                  ),
                                  maxLines: 2, // 최대 2줄까지만 표시
                                  overflow: TextOverflow.ellipsis, // 길어지면 ... 처리하는 파라미터
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}