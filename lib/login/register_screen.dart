import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _brandGreen = Color(0xFF639922);
  static const Color _brandGreenDark = Color(0xFF27500A);
  static const Color _brandGreenLight = Color(0xFFEAF3DE);

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();

  bool _passwordIsShow = false;
  bool _passwordConfirmIsShow = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  void _showDevelopingMessage() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('현재 개발 중인 기능입니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFDDEDC7), Color(0xFFF8FBF4), Color(0xFFF7F9F5)],
            stops: <double>[0, 0.34, 1],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 28),
                child: Column(
                  children: <Widget>[
                    _buildBrandHeader(),
                    const SizedBox(height: 20),
                    _buildRegisterCard(),
                    const SizedBox(height: 18),
                    Text(
                      '안심톡은 안전한 소통을 응원합니다.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: IconButton(
                  tooltip: '로그인으로 돌아가기',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _brandGreenDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return const Column(
      children: <Widget>[
        Icon(Icons.person_add_alt_1_rounded, color: _brandGreen, size: 46),
        SizedBox(height: 7),
        Text(
          '안심톡 시작하기',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: _brandGreenDark,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '간단한 정보 입력 후 바로 이용할 수 있어요.',
          style: TextStyle(fontSize: 15, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '회원가입',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: _brandGreenDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '정보를 입력해 계정을 만들어 주세요.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 18),
          _buildLabeledInput(
            label: '이름',
            controller: _nameCtrl,
            hintText: '이름을 입력해주세요',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 13),
          _buildLabeledInput(
            label: '이메일',
            controller: _emailCtrl,
            hintText: '이메일을 입력해주세요',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 13),
          _buildLabeledInput(
            label: '비밀번호',
            controller: _passwordCtrl,
            hintText: '비밀번호를 입력해주세요',
            icon: Icons.lock_outline_rounded,
            obscureText: !_passwordIsShow,
            suffixIcon: IconButton(
              tooltip: _passwordIsShow ? '비밀번호 숨기기' : '비밀번호 보기',
              onPressed: () => setState(() => _passwordIsShow = !_passwordIsShow),
              icon: Icon(
                _passwordIsShow ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 13),
          _buildLabeledInput(
            label: '비밀번호 확인',
            controller: _passwordConfirmCtrl,
            hintText: '비밀번호를 다시 입력해주세요',
            icon: Icons.lock_reset_outlined,
            obscureText: !_passwordConfirmIsShow,
            suffixIcon: IconButton(
              tooltip: _passwordConfirmIsShow ? '비밀번호 숨기기' : '비밀번호 보기',
              onPressed: () => setState(() => _passwordConfirmIsShow = !_passwordConfirmIsShow),
              icon: Icon(
                _passwordConfirmIsShow ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 15),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _agreeTerms = !_agreeTerms),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: _brandGreenLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _agreeTerms,
                      activeColor: _brandGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onChanged: (value) => setState(() => _agreeTerms = value ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '이용약관 및 개인정보 처리방침에 동의합니다',
                      style: TextStyle(fontSize: 14, color: _brandGreenDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                // 회원가입 처리 로직을 연결할 수 있습니다.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandGreen,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('회원가입 완료', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildSocialButton(
                  icon: const Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                  label: '구글',
                  onTap: _showDevelopingMessage,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSocialButton(
                  icon: const Icon(Icons.facebook_rounded, size: 20, color: Color(0xFF1877F2)),
                  label: '페이스북',
                  onTap: _showDevelopingMessage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: _brandGreenDark),
              child: const Text(
                '이미 계정이 있으신가요?  로그인하기',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledInput({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brandGreenDark),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 15, color: Colors.grey[500]),
              prefixIcon: Icon(icon, size: 23, color: _brandGreenDark),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: const Color(0xFFF8FBF5),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
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
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: icon,
        label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: const Color(0xFFFCFDF9),
          side: const BorderSide(color: Color(0xFFD8E6C6)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 6),
        ),
      ),
    );
  }
}
