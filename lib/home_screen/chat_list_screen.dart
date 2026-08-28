import 'dart:convert';

import 'package:ansim_talk/user_model/user_session.dart';
import 'package:ansim_talk/home_screen/detail_screens/chat_room_screen.dart';
import 'package:ansim_talk/home_screen/detail_screens/friend_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FriendModel {
  final int id;
  final String loginId;
  final String name;
  final String? profileImage;

  const FriendModel({
    required this.id,
    required this.loginId,
    required this.name,
    required this.profileImage,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: (json['id'] as num).toInt(),
      loginId: json['login_id'] as String? ?? '',
      name: json['name'] as String? ?? '이름 없음',
      profileImage: json['profile_image']?.toString(),
    );
  }
}

class ChatRoomModel {
  final int id;
  final int friendId;
  final String friendName;
  final String? profileImage;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatRoomModel({
    required this.id,
    required this.friendId,
    required this.friendName,
    required this.profileImage,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final friendJson = json['friend'] is Map
        ? Map<String, dynamic>.from(json['friend'] as Map)
        : <String, dynamic>{};

    return ChatRoomModel(
      id: (json['id'] as num).toInt(),
      friendId: (friendJson['id'] as num?)?.toInt() ?? 0,
      friendName: friendJson['name'] as String? ?? '알 수 없는 사용자',
      profileImage: friendJson['profile_image']?.toString(),
      lastMessage: json['last_message'] as String? ?? '',
      lastMessageAt: DateTime.tryParse(json['last_message_at'] as String? ?? ''),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ChatApiService {

  // todo : 해야할 일들
  //나중에 라이브러리 사용해서 이미지 네트워크로 가져온 profile이미지들 항시 유지시킬 예정임
  //현재 친구와 채팅방을 왔다갔다하면 튕기는 현상이 존재함 추후 이를 해결할 예정임 -> 아마 메모리, API등 때문인 것으로 보임
  //해당 문제 해결 후 다음으로 chatGPT를 이용한 보이스 피싱 응답을 채팅방에서 보여주도록 해야함

  static const String _baseUrl = 'http://210.114.17.158:8000';

  const ChatApiService();

  Map<String, String> get _headers => <String, String>{
    'Authorization': 'Bearer ${UserSession().token}',
    'accept': 'application/json',
  };

  Future<List<FriendModel>> getFriends() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/v1/friends'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    final body = _decodeSuccessResponse(response, '친구 목록');
    final data = Map<String, dynamic>.from(body['data'] as Map);
    final friendsJson = List<dynamic>.from(data['friends'] as List? ?? const <dynamic>[]);

    return friendsJson
        .map((item) => FriendModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<List<ChatRoomModel>> getChats() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/v1/chats'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    final body = _decodeSuccessResponse(response, '채팅방 목록');
    final data = Map<String, dynamic>.from(body['data'] as Map);
    final chatsJson = List<dynamic>.from(data['chats'] as List? ?? const <dynamic>[]);

    return chatsJson
        .map((item) => ChatRoomModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Map<String, dynamic> _decodeSuccessResponse(
      http.Response response,
      String requestName,
      ) {
    if (response.statusCode == 401) {
      throw Exception('로그인이 만료되었습니다. 다시 로그인해 주세요.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('$requestName 요청에 실패했습니다. (HTTP ${response.statusCode})');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map) {
      throw Exception('$requestName 응답 형식이 올바르지 않습니다.');
    }

    final body = Map<String, dynamic>.from(decoded);
    if (body['success'] != true || body['data'] is! Map) {
      throw Exception('$requestName 데이터를 불러오지 못했습니다.');
    }
    return body;
  }
}

enum _ChatListTab { friends, chats }

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  static const Color _brandGreen = Color(0xFF639922);
  static const Color _brandGreenDark = Color(0xFF27500A);
  static const Color _brandGreenLight = Color(0xFFEAF3DE);

  final ChatApiService _apiService = const ChatApiService();
  final TextEditingController _searchController = TextEditingController();

  List<FriendModel> _friends = <FriendModel>[];
  List<ChatRoomModel> _chatRooms = <ChatRoomModel>[];
  _ChatListTab _selectedTab = _ChatListTab.friends;

  bool _isFriendsLoading = false;
  bool _isChatsLoading = false;
  String? _friendsError;
  String? _chatsError;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _loadChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    if (_isFriendsLoading) return;
    if (UserSession().token.isEmpty) {
      setState(() => _friendsError = '로그인 정보가 없습니다. 다시 로그인해 주세요.');
      return;
    }

    setState(() {
      _isFriendsLoading = true;
      _friendsError = null;
    });

    try {
      final friends = await _apiService.getFriends();
      if (!mounted) return;
      setState(() => _friends = friends);
    } catch (error) {
      if (!mounted) return;
      setState(() => _friendsError = error.toString());
    } finally {
      if (mounted) setState(() => _isFriendsLoading = false);
    }
  }

  Future<void> _loadChats() async {
    if (_isChatsLoading) return;
    if (UserSession().token.isEmpty) {
      setState(() => _chatsError = '로그인 정보가 없습니다. 다시 로그인해 주세요.');
      return;
    }

    setState(() {
      _isChatsLoading = true;
      _chatsError = null;
    });

    try {
      final rooms = await _apiService.getChats();
      if (!mounted) return;
      setState(() => _chatRooms = rooms);
    } catch (error) {
      if (!mounted) return;
      setState(() => _chatsError = error.toString());
    } finally {
      if (mounted) setState(() => _isChatsLoading = false);
    }
  }

  void _selectTab(_ChatListTab tab) {
    if (_selectedTab == tab) {
      _refreshCurrentTab();
      return;
    }

    setState(() => _selectedTab = tab);
    if (tab == _ChatListTab.friends) {
      _loadFriends();
    } else {
      _loadChats();
    }
  }

  Future<void> _refreshCurrentTab() {
    return _selectedTab == _ChatListTab.friends ? _loadFriends() : _loadChats();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _searchController.text.trim();
    final friends = _friends.where((friend) {
      return friend.name.contains(keyword) || friend.loginId.contains(keyword);
    }).toList();
    final rooms = _chatRooms.where((room) {
      return room.friendName.contains(keyword) || room.lastMessage.contains(keyword);
    }).toList();

    return SafeArea(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFFF7F9F5)),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildTabBar(),
            const SizedBox(height: 12),
            _buildSearchField(keyword),
            const SizedBox(height: 8),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                reverseDuration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offsetAnimation, child: child),
                  );
                },
                child: _selectedTab == _ChatListTab.friends
                    ? KeyedSubtree(
                  key: const ValueKey<String>('friends'),
                  child: _buildFriendsView(friends, keyword),
                )
                    : KeyedSubtree(
                  key: const ValueKey<String>('chats'),
                  child: _buildChatsView(rooms, keyword),
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF4C7B1C), _brandGreen, Color(0xFF7EAC3B)],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _brandGreen.withValues(alpha: 0.20),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: <Widget>[
            Icon(Icons.forum_rounded, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '대화',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ),
            Icon(Icons.shield_outlined, color: Color(0xD9FFFFFF), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 58,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE7EEE0),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Stack(
          children: <Widget>[
            AnimatedAlign(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeInOutCubic,
              alignment: _selectedTab == _ChatListTab.friends
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.09),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                _buildTabButton(
                  tab: _ChatListTab.friends,
                  label: '친구',
                  icon: Icons.people_alt_outlined,
                ),
                const SizedBox(width: 4),
                _buildTabButton(
                  tab: _ChatListTab.chats,
                  label: '채팅방',
                  icon: Icons.chat_bubble_outline_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required _ChatListTab tab,
    required String label,
    required IconData icon,
  }) {
    final selected = _selectedTab == tab;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: '$label 탭',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(13),
          child: SizedBox.expand(
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () => _selectTab(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(icon, size: 21, color: selected ? _brandGreenDark : Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                          color: selected ? _brandGreenDark : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(String keyword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 54,
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            hintText: _selectedTab == _ChatListTab.friends
                ? '친구 이름을 찾아보세요'
                : '채팅방 또는 메시지를 찾아보세요',
            hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.search, color: _brandGreenDark, size: 25),
            suffixIcon: keyword.isEmpty
                ? null
                : IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Icons.clear, size: 24),
              tooltip: '검색어 지우기',
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE1E8D9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _brandGreen, width: 1.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsView(List<FriendModel> friends, String keyword) {
    if (_isFriendsLoading && _friends.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _brandGreen));
    }
    if (_friendsError != null && _friends.isEmpty) {
      return _buildErrorState(_friendsError!, _loadFriends);
    }
    if (friends.isEmpty) {
      return _buildEmptyState(
        icon: Icons.people_outline_rounded,
        message: keyword.isEmpty ? '등록된 친구가 없습니다.' : '찾으시는 친구가 없습니다.',
      );
    }

    return RefreshIndicator(
      color: _brandGreen,
      onRefresh: _loadFriends,
      child: ListView.separated(
        key: const PageStorageKey<String>('friends-list'),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        itemCount: friends.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) return _buildListTitle('친구', '${friends.length}명');
          return _buildFriendCard(friends[index - 1]);
        },
      ),
    );
  }

  Widget _buildChatsView(List<ChatRoomModel> rooms, String keyword) {
    if (_isChatsLoading && _chatRooms.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _brandGreen));
    }
    if (_chatsError != null && _chatRooms.isEmpty) {
      return _buildErrorState(_chatsError!, _loadChats);
    }
    if (rooms.isEmpty) {
      return _buildEmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        message: keyword.isEmpty ? '참여 중인 채팅방이 없습니다.' : '찾으시는 채팅방이 없습니다.',
      );
    }

    return RefreshIndicator(
      color: _brandGreen,
      onRefresh: _loadChats,
      child: ListView.separated(
        key: const PageStorageKey<String>('chats-list'),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        itemCount: rooms.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) return _buildListTitle('채팅방', '${rooms.length}개');
          return _buildChatRoomCard(rooms[index - 1]);
        },
      ),
    );
  }

  Widget _buildListTitle(String title, String count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
      child: Row(
        children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(width: 7),
          Text(count, style: const TextStyle(fontSize: 15, color: _brandGreenDark)),
        ],
      ),
    );
  }

  Widget _buildFriendCard(FriendModel friend) {
    ChatRoomModel? linkedChat;
    for (final room in _chatRooms) {
      if (room.friendId == friend.id) {
        linkedChat = room;
        break;
      }
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FriendProfileScreen(
                friendName: friend.name,
                profileImage: friend.profileImage,
                chatId: linkedChat?.id,
                lastMessage: linkedChat?.lastMessage,
              ),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 82),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE1E8D9)),
          ),
          child: Row(
            children: <Widget>[
              _buildProfileAvatar(friend.profileImage, friend.name),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      friend.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      friend.loginId.isEmpty ? '친구' : '@${friend.loginId}',
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded, size: 29, color: _brandGreenDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatRoomCard(ChatRoomModel room) {
    final hasUnread = room.unreadCount > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatRoomScreen(
                chatId: room.id,
                friendName: room.friendName,
                profileImage: room.profileImage,
              ),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 92),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: hasUnread ? const Color(0xFFBED99A) : const Color(0xFFE1E8D9),
              width: hasUnread ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              _buildProfileAvatar(room.profileImage, room.friendName),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            room.friendName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatChatTime(room.lastMessageAt),
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            room.lastMessage.isEmpty ? '아직 메시지가 없습니다.' : room.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.25),
                          ),
                        ),
                        if (hasUnread) ...<Widget>[
                          const SizedBox(width: 9),
                          _buildUnreadBadge(room.unreadCount),
                        ],
                      ],
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

  Widget _buildProfileAvatar(String? profileImage, String name) {
    final initial = name.trim().isEmpty ? '?' : name.trim().substring(0, 1);
    final fallback = CircleAvatar(
      radius: 29,
      backgroundColor: _brandGreenLight,
      child: Text(
        initial,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: _brandGreenDark),
      ),
    );

    final image = profileImage?.trim();
    if (image == null || image.isEmpty) return fallback;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCFE2B5), width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          _resolveProfileImageUrl(image),
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(int unreadCount) {
    return Container(
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: _brandGreen, shape: BoxShape.circle),
      child: Text(
        unreadCount > 99 ? '99+' : '$unreadCount',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return RefreshIndicator(
      color: _brandGreen,
      onRefresh: _refreshCurrentTab,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          const SizedBox(height: 100),
          Icon(icon, size: 52, color: _brandGreen),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            '아래로 당기면 다시 불러올 수 있습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, Future<void> Function() onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 46, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              height: 46,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _brandGreenDark,
                  side: const BorderSide(color: _brandGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveProfileImageUrl(String profileImage) {
    final image = profileImage.trim();
    if (Uri.tryParse(image)?.hasScheme ?? false) return image;
    return image.startsWith('/')
        ? 'http://210.114.17.158:8000$image'
        : 'http://210.114.17.158:8000/$image';
  }

  String _formatChatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final localTime = time.toLocal();
    final isToday = now.year == localTime.year &&
        now.month == localTime.month &&
        now.day == localTime.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == localTime.year &&
        yesterday.month == localTime.month &&
        yesterday.day == localTime.day;

    if (isToday) {
      final hour = localTime.hour.toString().padLeft(2, '0');
      final minute = localTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    if (isYesterday) return '어제';
    return '${localTime.month}/${localTime.day}';
  }
}
