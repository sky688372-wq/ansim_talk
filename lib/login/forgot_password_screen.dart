import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  /// 시연용 화면이라 실제로 기능은 하지는 않을 거임

  static const Color _brandGreen = Color(0xFF639922);
  static const Color _brandGreenDark = Color(0xFF27500A);
  static const Color _brandGreenLight = Color(0xFFEAF3DE);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isComplete = false;

  @override
  void dispose() {
    _idController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _showDemoCompletion() {
    if (_idController.text.trim().isEmpty || _contactController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아이디와 연락처를 모두 입력해 주세요.')),
      );
      return;
    }

    setState(() => _isComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFDDEDC7), Color(0xFFF8FBF4), Color(0xFFF7F9F5)],
            stops: <double>[0, 0.42, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: '로그인으로 돌아가기',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _brandGreenDark),
                  ),
                ),
                const Spacer(),
                _buildHeader(),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _isComplete ? _buildCompleteCard() : _buildFormCard(),
                ),
                const Spacer(flex: 2),
                Text(
                  '안심톡은 안전한 소통을 응원합니다.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: <Widget>[
        Icon(Icons.lock_reset_rounded, size: 48, color: _brandGreen),
        SizedBox(height: 10),
        Text(
          '비밀번호 찾기',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: _brandGreenDark,
          ),
        ),
        SizedBox(height: 6),
        Text(
          '본인 확인 후 비밀번호를 다시 설정할 수 있어요.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      key: const ValueKey<String>('form'),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '계정 정보 확인',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: _brandGreenDark),
          ),
          const SizedBox(height: 5),
          Text(
            '가입할 때 등록한 정보를 입력해 주세요.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const Text('아이디', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _idController,
            hintText: '아이디를 입력해주세요',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          const Text('연락처', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _buildInput(
            controller: _contactController,
            hintText: '휴대폰 번호를 입력해주세요',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 17),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _showDemoCompletion,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandGreen,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                '인증 안내 받기',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 11),

        ],
      ),
    );
  }

  Widget _buildCompleteCard() {
    return Container(
      key: const ValueKey<String>('complete'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      decoration: _cardDecoration(),
      child: Column(
        children: <Widget>[
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(color: _brandGreenLight, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, size: 34, color: _brandGreenDark),
          ),
          const SizedBox(height: 15),
          const Text(
            '인증 안내를 준비했어요',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: _brandGreenDark),
          ),
          const SizedBox(height: 8),
          Text(
            '${_contactController.text.trim()}로\n비밀번호 재설정 안내를 보냈습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.45, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),
          const Text(
            '시연용 화면이므로 실제 메시지는 전송되지 않습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandGreen,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('로그인 화면으로 돌아가기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[500]),
          prefixIcon: Icon(icon, size: 23, color: _brandGreenDark),
          filled: true,
          fillColor: const Color(0xFFF8FBF5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFFE0E8D6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: _brandGreen, width: 1.6),
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFE1EAD7)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
