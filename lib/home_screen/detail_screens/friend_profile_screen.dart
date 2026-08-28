import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class FriendProfileScreen extends StatelessWidget {
  const FriendProfileScreen({
    super.key,
    required this.friendName,
    this.profileImage,
    this.chatId,
    this.lastMessage,
  });

  final String friendName;
  final String? profileImage;
  final int? chatId;
  final String? lastMessage;

  static const String _baseUrl = 'http://210.114.17.158:8000';
  static const Color _green = Color(0xFF639922);
  static const Color _darkGreen = Color(0xFF27500A);
  static const Color _lightGreen = Color(0xFFEAF3DE);
  static const Color _background = Color(0xFFF7F9F5);

  String get _displayName {
    final value = friendName.trim();
    return value.isEmpty ? '이름 없음' : value;
  }

  String get _initial => _displayName.substring(0, 1);

  String? get _imageUrl {
    final image = profileImage?.trim();
    if (image == null || image.isEmpty) return null;
    if (Uri.tryParse(image)?.hasScheme ?? false) return image;
    return image.startsWith('/') ? '$_baseUrl$image' : '$_baseUrl/$image';
  }

  bool get _hasRecentMessage => lastMessage != null && lastMessage!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _darkGreen,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 30),
          tooltip: '뒤로가기',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '친구 프로필',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            children: <Widget>[
              _buildProfileHeader(),
              const SizedBox(height: 22),
              _buildFriendIdentity(),
              const SizedBox(height: 28),
              if (chatId != null) _buildRecentConversation(),
              if (chatId != null) const SizedBox(height: 22),
              if (chatId != null) _buildChatButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: double.infinity,
      height: 270,
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFD6E7C2), width: 1.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: _green.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _imageUrl == null
          ? _buildFallbackImageArea()
          : Image.network(
        _imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildFallbackImageArea(),
      ),
    );
  }

  Widget _buildFallbackImageArea() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFEAF3DE), Color(0xFFF5F9EF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initial,
        style: const TextStyle(
          fontSize: 104,
          fontWeight: FontWeight.w800,
          color: _green,
        ),
      ),
    );
  }

  Widget _buildFriendIdentity() {
    return Column(
      children: <Widget>[
        Text(
          _displayName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: _darkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _lightGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '안심톡 친구',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _darkGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentConversation() {
    final message = _hasRecentMessage ? lastMessage!.trim() : '아직 대화가 없습니다.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E8D9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(Icons.forum_outlined, color: _green, size: 24),
              SizedBox(width: 8),
              Text(
                '최근 대화',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _darkGreen),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              height: 1.35,
              color: _hasRecentMessage ? Colors.grey[800] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatRoomScreen(
                chatId: chatId!,
                friendName: _displayName,
                profileImage: profileImage,
              ),
            ),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 24),
        label: const Text(
          '채팅하기',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        ),
      ),
    );
  }
}
