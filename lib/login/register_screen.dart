import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 입력 컨트롤러
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();

  // 상태 관리 변수
  bool _passwordIsShow = false;
  bool _passwordConfirmIsShow = false;
  bool _agreeTerms = false; // 약관 동의 체크박스

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightGreen,
              Colors.white.withValues(alpha: 0.7),
            ],
          ),
        ),
        // Stack 구조로 변경
        child: Stack(
          children: [
            // 1. 메인 콘텐츠 스크롤 영역
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    // 뒤로 가기 버튼과 겹치지 않도록 상단 여백 추가
                    const SizedBox(height: 40),

                    // 상단 브랜드 로고 및 앱 이름
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo/app_icon.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.shield, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "안심톡",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 메인 흰색 Card 컨테이너
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 타이틀: 회원가입
                          const Center(
                            child: Text(
                              "회원가입",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 서브타이틀: 로그인 이동
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "이미 계정이 있으신가요?",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "로그인하기",
                                  style: TextStyle(
                                    color: Color(0xFF2575FC),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 1) 이름 입력 영역
                          const Text(
                            "이름",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameCtrl,
                            keyboardType: TextInputType.name,
                            decoration: _buildInputDecoration("이름을 입력해주세요"),
                          ),

                          const SizedBox(height: 16),

                          // 2) 이메일 입력 영역
                          const Text(
                            "이메일",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration("이메일을 입력해주세요"),
                          ),

                          const SizedBox(height: 16),

                          // 3) 비밀번호 입력 영역
                          const Text(
                            "비밀번호",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: !_passwordIsShow,
                            decoration: _buildInputDecoration(
                              "비밀번호를 입력해주세요",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordIsShow = !_passwordIsShow;
                                  });
                                },
                                icon: Icon(
                                  _passwordIsShow
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 4) 비밀번호 확인 입력 영역
                          const Text(
                            "비밀번호 확인",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordConfirmCtrl,
                            obscureText: !_passwordConfirmIsShow,
                            decoration: _buildInputDecoration(
                              "비밀번호를 다시 입력해주세요",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordConfirmIsShow = !_passwordConfirmIsShow;
                                  });
                                },
                                icon: Icon(
                                  _passwordConfirmIsShow
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // 5) 이용약관 동의 체크박스
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreeTerms,
                                  activeColor: const Color(0xFF2575FC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeTerms = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "이용약관 및 개인정보 처리방침에 동의합니다",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // 6) 회원가입 버튼
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                // 회원가입 처리 로직
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2575FC),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "회원가입 완료",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // 7) 또는 구분선
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "또는",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // 8) 소셜 가입 버튼
                          _buildSocialButton(
                            icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                            label: "구글 계정으로 가입하기",
                            onTap: () {
                              //임시로 기능 구현 중 알림
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                  "현재 개발중인 기능입니다.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ))
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSocialButton(
                            icon: const Icon(Icons.facebook, size: 22, color: Color(0xFF1877F2)),
                            label: "페이스북으로 가입하기",
                            onTap: () {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "현재 개발중인 기능입니다.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ))
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. 상단 고정 뒤로 가기 버튼 (Stack의 맨 위에 위치)
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 공통 TextField Decoration 함수
  InputDecoration _buildInputDecoration(String hintText, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2575FC)),
      ),
    );
  }

  // 소셜 로그인/가입 버튼 공통 위젯
  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}