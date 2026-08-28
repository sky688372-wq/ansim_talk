import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ansim_talk/user_model/user_session.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    this.chatId = 1,
    this.friendName = '박민수',
    this.profileImage,
  });

  // 기본값을 1로 두어 기존 ChatRoomScreen() 호출도 그대로 동작합니다.
  final int chatId;
  final String friendName;
  final String? profileImage;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  static const String _baseUrl = 'http://210.114.17.158:8000';
  static const Color _green = Color(0xFF639922);
  static const Color _darkGreen = Color(0xFF27500A);
  static const Color _background = Color(0xFFF7F9F5);

  // 현재 테스트 계정 demo01의 user.id가 1이므로 시연용으로 사용합니다.
  // UserSession에 userId를 추가했다면 UserSession().userId로 바꾸세요.
  static const int _currentUserId = 1;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> _messages = <MessageModel>[];
  String _friendName = '';
  String? _profileImage;
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _friendName = widget.friendName;
    _profileImage = widget.profileImage;
    debugPrint('[ChatRoomScreen] initState 실행: chatId=${widget.chatId}, 초기 상대방=$_friendName');
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages({bool showLoading = true}) async {
    final token = UserSession().token.trim();
    debugPrint('[ChatRoomScreen][GET] 조회 시작: chatId=${widget.chatId}');
    debugPrint('[ChatRoomScreen][GET] token 존재 여부=${token.isNotEmpty}, 길이=${token.length}');

    if (token.isEmpty) {
      debugPrint('[ChatRoomScreen][GET] 중단: UserSession token이 비어 있습니다.');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = '로그인 정보가 없습니다. 다시 로그인해 주세요.';
      });
      return;
    }

    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final url = Uri.parse('$_baseUrl/api/v1/chats/${widget.chatId}/messages');
    debugPrint('[ChatRoomScreen][GET] 요청 URL=$url');
    debugPrint('[ChatRoomScreen][GET] HTTP GET 전송');

    try {
      final response = await http
          .get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 15));

      debugPrint('[ChatRoomScreen][GET] 응답 수신: status=${response.statusCode}, bodyLength=${response.bodyBytes.length}');
      debugPrint('[ChatRoomScreen][GET] 응답 본문=${utf8.decode(response.bodyBytes)}');
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      debugPrint('[ChatRoomScreen][GET] JSON 디코딩 완료: type=${decoded.runtimeType}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('HTTP ${response.statusCode}');
      }
      if (decoded is! Map || decoded['success'] != true) {
        throw const FormatException('메시지 응답이 올바르지 않습니다.');
      }

      final rawData = decoded['data'];
      if (rawData is! Map) {
        throw const FormatException('응답에 data가 없습니다.');
      }

      final data = Map<String, dynamic>.from(rawData);
      final rawChat = data['chat'];
      final rawMessages = data['messages'];
      debugPrint('[ChatRoomScreen][GET] data 키=${data.keys.toList()}');
      debugPrint('[ChatRoomScreen][GET] messages 타입=${rawMessages.runtimeType}, 원본 개수=${rawMessages is List ? rawMessages.length : '확인 불가'}');

      if (rawMessages is! List) {
        throw const FormatException('응답에 messages가 없습니다.');
      }

      String? name = _friendName;
      String? image = _profileImage;
      if (rawChat is Map) {
        final chat = Map<String, dynamic>.from(rawChat);
        final rawFriend = chat['friend'];
        if (rawFriend is Map) {
          final friend = Map<String, dynamic>.from(rawFriend);
          name = friend['name']?.toString() ?? name;
          image = friend['profile_image']?.toString() ?? image;
        }
      }

      final messages = rawMessages
          .whereType<Map>()
          .map((item) => MessageModel.fromJson(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

      debugPrint('[ChatRoomScreen][GET] 모델 변환 완료: ${messages.length}개');
      debugPrint('[ChatRoomScreen][GET] 상대방 이름=$name, 프로필 존재 여부=${image != null && image.isNotEmpty}');
      if (!mounted) {
        debugPrint('[ChatRoomScreen][GET] 화면 종료로 반영 생략');
        return;
      }
      setState(() {
        _friendName = name ?? '대화 상대';
        _profileImage = image;
        _messages = messages;
        _isLoading = false;
        _errorMessage = null;
      });
      debugPrint('[ChatRoomScreen][GET] 화면 반영 완료: 현재 메시지=${_messages.length}개');
      _scrollToBottom();
    } catch (error, stackTrace) {
      debugPrint('[ChatRoomScreen][GET] 메시지 조회 오류: $error');
      debugPrint('[ChatRoomScreen][GET] stackTrace=\n$stackTrace');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = '메시지를 불러오지 못했습니다.\n잠시 후 다시 시도해 주세요.';
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    final token = UserSession().token.trim();
    debugPrint('[ChatRoomScreen][POST] 전송 시도: chatId=${widget.chatId}, contentLength=${content.length}');
    debugPrint('[ChatRoomScreen][POST] token 존재 여부=${token.isNotEmpty}, 길이=${token.length}');

    if (content.isEmpty) {
      debugPrint('[ChatRoomScreen][POST] 중단: 메시지 내용이 비어 있습니다.');
      return;
    }
    if (_isSending) {
      debugPrint('[ChatRoomScreen][POST] 중단: 이미 전송 중입니다.');
      return;
    }
    if (token.isEmpty) {
      _showSnackBar('로그인 정보가 없습니다. 다시 로그인해 주세요.');
      return;
    }

    setState(() => _isSending = true);
    final url = Uri.parse('$_baseUrl/api/v1/chats/${widget.chatId}/messages');
    debugPrint('[ChatRoomScreen][POST] 요청 URL=$url');
    debugPrint('[ChatRoomScreen][POST] HTTP POST 전송');

    try {
      final response = await http
          .post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode(<String, String>{'content': content}),
      )
          .timeout(const Duration(seconds: 15));

      debugPrint('[ChatRoomScreen][POST] 응답 수신: status=${response.statusCode}, bodyLength=${response.bodyBytes.length}');
      debugPrint('[ChatRoomScreen][POST] 응답 본문=${utf8.decode(response.bodyBytes)}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('HTTP ${response.statusCode}');
      }

      debugPrint('[ChatRoomScreen][POST] 전송 성공');
      _messageController.clear();
      debugPrint('[ChatRoomScreen][POST] 입력창 초기화 후 GET 재조회');
      await _loadMessages(showLoading: false);
    } catch (error, stackTrace) {
      debugPrint('[ChatRoomScreen][POST] 메시지 전송 오류: $error');
      debugPrint('[ChatRoomScreen][POST] stackTrace=\n$stackTrace');
      _showSnackBar('메시지를 보내지 못했습니다. 다시 시도해 주세요.');
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
        debugPrint('[ChatRoomScreen][POST] 전송 상태 종료');
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: _buildAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildMessageArea()),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 76,
      elevation: 0,
      backgroundColor: const Color(0xFFEAF3DE),
      foregroundColor: _darkGreen,
      leading: IconButton(
        tooltip: '뒤로가기',
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 23),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Row(
        children: <Widget>[
          _buildAvatar(48),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  _friendName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                const Text(
                  '안심 대화',
                  style: TextStyle(fontSize: 13, color: Color(0xFF617058), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD1E2C0)),
          ),
          child: Text(
            '#${widget.chatId}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _darkGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageArea() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: _green));
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFF8EA57E)),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _loadMessages,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('다시 시도', style: TextStyle(fontSize: 16)),
              style: OutlinedButton.styleFrom(foregroundColor: _darkGreen),
            ),
          ],
        ),
      );
    }
    if (_messages.isEmpty) {
      return RefreshIndicator(
        color: _green,
        onRefresh: _loadMessages,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const <Widget>[
            SizedBox(height: 150),
            Icon(Icons.chat_bubble_outline_rounded, size: 54, color: Color(0xFF9DB88C)),
            SizedBox(height: 14),
            Text('아직 대화가 없습니다.\n첫 메시지를 보내보세요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 17, height: 1.5)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _green,
      onRefresh: _loadMessages,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          final showDate = index == 0 || !_isSameDay(_messages[index - 1].sentAt, message.sentAt);
          return Column(
            children: <Widget>[
              if (showDate) _buildDateDivider(message.sentAt),
              _buildMessageBubble(message),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          const Expanded(child: Divider(color: Color(0xFFDCE6D6))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '${date.year}년 ${date.month}월 ${date.day}일',
              style: const TextStyle(fontSize: 13, color: Color(0xFF687564), fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFDCE6D6))),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isMine = message.senderId == _currentUserId;
    final bubble = Flexible(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMine ? _green : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 18 : 5),
            bottomRight: Radius.circular(isMine ? 5 : 18),
          ),
          border: isMine ? null : Border.all(color: const Color(0xFFDCE6D6)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black.withValues(alpha: 0.035), blurRadius: 7, offset: const Offset(0, 3)),
          ],
        ),
        child: Text(
          message.content,
          style: TextStyle(color: isMine ? Colors.white : const Color(0xFF20251F), fontSize: 18, height: 1.4, fontWeight: FontWeight.w500),
        ),
      ),
    );
    final time = Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text(_formatTime(message.sentAt), style: const TextStyle(fontSize: 12, color: Color(0xFF788276))),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: isMine ? <Widget>[time, const SizedBox(width: 6), bubble] : <Widget>[bubble, const SizedBox(width: 6), time],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              tooltip: '첨부 기능 준비 중',
              onPressed: () => _showSnackBar('첨부 기능은 준비 중입니다.'),
              icon: const Icon(Icons.add_circle_outline_rounded, color: _green, size: 29),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 3,
                style: const TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFFF4F7F1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              height: 48,
              child: _isSending
                  ? const Padding(padding: EdgeInsets.all(13), child: CircularProgressIndicator(strokeWidth: 3, color: _green))
                  : ElevatedButton(
                onPressed: _sendMessage,
                style: ElevatedButton.styleFrom(backgroundColor: _green, foregroundColor: Colors.white, padding: EdgeInsets.zero, shape: const CircleBorder()),
                child: const Icon(Icons.send_rounded, size: 23),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(double size) {
    final initial = _friendName.trim().isEmpty ? '?' : _friendName.trim().substring(0, 1);
    if (_profileImage == null || _profileImage!.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: const Color(0xFFDCEBCB),
        child: Text(initial, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _darkGreen)),
      );
    }

    final imageUrl = _profileImage!.startsWith('http') ? _profileImage! : '$_baseUrl$_profileImage';
    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => CircleAvatar(
          radius: size / 2,
          backgroundColor: const Color(0xFFDCEBCB),
          child: Text(initial, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _darkGreen)),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatTime(DateTime date) {
    final period = date.hour < 12 ? '오전' : '오후';
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    return '$period $hour:${date.minute.toString().padLeft(2, '0')}';
  }
}

class MessageModel {
  const MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  final int id;
  final int chatId;
  final int senderId;
  final String content;
  final DateTime sentAt;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      chatId: (json['chat_id'] as num?)?.toInt() ?? 0,
      senderId: (json['sender_id'] as num?)?.toInt() ?? 0,
      content: json['content']?.toString() ?? '',
      sentAt: DateTime.tryParse(json['sent_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
