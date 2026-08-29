import 'package:flutter/material.dart';

class GuardianConnectScreen extends StatelessWidget {
  const GuardianConnectScreen({
    super.key,
    this.guardianName = '이서연',
    this.relationship = '딸',
    this.profileImage,
  });

  final String guardianName;
  final String relationship;
  final String? profileImage;

  static const Color brandGreen = Color(0xFF639922);
  static const Color darkGreen = Color(0xFF27500A);
  static const Color lightGreen = Color(0xFFEAF3DE);
  static const Color background = Color(0xFFF7F9F5);

  String get _initial {
    final name = guardianName.trim();
    return name.isEmpty ? '?' : name.substring(0, 1);
  }

  Widget _buildGuardianAvatar() {
    final image = profileImage?.trim();

    final fallback = Container(
      color: lightGreen,
      alignment: Alignment.center,
      child: Text(
        _initial,
        style: const TextStyle(
          fontSize: 58,
          fontWeight: FontWeight.w800,
          color: darkGreen,
        ),
      ),
    );

    if (image == null || image.isEmpty) {
      return fallback;
    }

    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
    );
  }

  void _showDemoMessage(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            '시연용 화면입니다. 보호자 연결 기능은 준비 중입니다.',
            style: TextStyle(fontSize: 15),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          '보호자 연결',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: lightGreen,
        foregroundColor: darkGreen,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD7E7C8)),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x16000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const Icon(
                      Icons.family_restroom_rounded,
                      size: 34,
                      color: brandGreen,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '도움이 필요할 때\n보호자에게 알려주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 22),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: AspectRatio(
                        aspectRatio: 1.05,
                        child: _buildGuardianAvatar(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      guardianName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        relationship,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 58,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showDemoMessage(context),
                        icon: const Icon(Icons.contact_phone_rounded, size: 25),
                        label: const Text(
                          '보호자에게 알리기',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEADDB9)),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info_outline_rounded, color: Color(0xFF8A6A18), size: 25),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '의심스러운 연락을 받았다면 먼저 전화를 끊고, 보호자나 공식 기관에 직접 확인하세요.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5D4B1A),
                        ),
                      ),
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
}
