import 'package:flutter/material.dart';
import 'package:ansim_talk/user_model/user_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {


  //가짜 페이크 리스트들임
  List<UserModel> dummyUsers = [
    UserModel(
      name: '김민준',
      imgPath: 'assets/images/user1.png', // 사용할 이미지 경로 지정
      introduce: '안녕하세요! 모바일 앱 개발과 UX/UI 디자인에 관심이 많은 3년 차 프론트엔드 개발자입니다.',
    ),
    UserModel(
      name: '이지은',
      imgPath: 'assets/images/user2.png',
      introduce: '일상의 소소한 순간들을 사진으로 기록하는 것을 좋아합니다. 소통하는 거 환영해요! 📸',
    ),
    UserModel(
      name: '박현우',
      imgPath: 'assets/images/user3.png',
      introduce: '스타트업에서 기획을 담당하고 있습니다. 맛집 탐방과 주말 러닝이 취미입니다. 🏃‍♂️',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 이 부분은 오직 유저의 프로필 사진, 간단 설명, 이름을 담은 리스트 빌더만 배치하면 될 듯함
        //채팅 디테일 스크린은 그냥 나중에 home_screens 폴더의 하위 디렉토리 만들어서 모아두면 될 듯
      ],
    );
  }
}
