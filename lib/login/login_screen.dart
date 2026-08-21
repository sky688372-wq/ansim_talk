import 'package:ansim_talk/introduce/intro_manage_screen.dart';
import 'package:ansim_talk/login/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//이

class _LoginScreenState extends State<LoginScreen> {

  final String email = "test@gmail.com";
  final String password = "test1234!";


  //이메일 유효성 검사 : 백엔드 완성되면 전달받아서 하면 될 듯함

  //실제로는 구상만 하면 되므로 임시 비밀번호를 하나 만들어두고 그를 이용해서 로그인 구현을 하면 될 듯함
  // 나중에 openAI API를 통해서 불러오는 부분만 하여 최대한 백엔드의 부담을 줄이고 AI 부분에 신경쓸 수 있도록 할거임


  // 입력 컨트롤러
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  // 상태 관리 변수
  bool _passwordIsShow = false;
  bool _rememberMe = false; // 로그인 상태 유지 체크박스

  // 로그인 시도 로직
  void _login() {
    String inputEmail = _emailCtrl.text.trim();
    String inputPassword = _passwordCtrl.text.trim();

    if (inputEmail == email && inputPassword == password) {
      // 로그인 성공
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const IntroManageScreen(), //시연을 위해 로그인 하더라도 항상 introducr화면들이 뜨도록 할거임
        ),
      );
    } else {
      // 로그인 실패
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 또는 비밀번호가 올바르지 않습니다.'),
        ),
      );
    }
  }


  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1. 전체 배경 블루-민트 그라데이션 적용
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightGreen, // 상단 파란색
              Colors.white.withValues(alpha: 0.7), // 하단 민트/시안색
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 2. 상단 브랜드 로고 및 앱 이름
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo/app_icon.png',
                      width: 36,
                      height: 36,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shield,
                        color: Colors.white,
                        size: 36,
                      ),
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

                const SizedBox(height: 30),

                // 3. 메인 흰색 Card 형태 컨테이너
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
                      // 타이틀: Login
                      const Center(
                        child: Text(
                          "로그인",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 서브타이틀: 가입 유도 부분
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "계정이 없으신가요?",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),

                          SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              // 회원가입 페이지 이동 로직
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "지금 계정을 만들어보세요",
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

                      // 이메일 입력 영역
                      const Text(
                        "이메일",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,

                        // 입력하면서 실시간 검사
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '이메일을 입력해주세요.';
                          }

                          final emailRegex = RegExp(
                            r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$',
                          );

                          if (!emailRegex.hasMatch(value.trim())) {
                            return '올바른 이메일 형식이 아닙니다.';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          hintText: "이메일을 입력해주세요",
                          hintStyle: TextStyle(color: Colors.grey.shade400),

                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2575FC),
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 비밀번호 입력 영역
                      const Text(
                        "비밀번호",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _passwordCtrl,

                        obscureText: !_passwordIsShow,

                        // 입력하면서 실시간 검사
                        autovalidateMode: AutovalidateMode.onUserInteraction,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요.';
                          }

                          if (value.length < 8) {
                            return '비밀번호는 8자 이상이어야 합니다.';
                          }

                          if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                            return '영문을 포함해주세요.';
                          }

                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return '숫자를 포함해주세요.';
                          }

                          if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                            return '특수문자를 포함해주세요.';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          hintText: "비밀번호를 입력해주세요",
                          hintStyle: TextStyle(color: Colors.grey.shade400),

                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

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

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF2575FC),
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 4. Remember me & Forgot Password Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: const Color(0xFF2575FC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "로그인 유지",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // 비밀번호 찾기 로직
                            },
                            child: const Text(
                              "비밀번호를 잊으셨나요?",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2575FC),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 5. Log In 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // 로그인 처리 로직 : 일단 테스틀용으로 임시임
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IntroManageScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2575FC),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "로그인",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 6. Or 구분선
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

                      // 7. 그외 로그인 버튼
                      _buildSocialButton(
                        icon: const Icon(
                          SimpleIcons.google,
                          size: 22,
                          color: SimpleIconColors.google,
                        ),
                        label: "구글 계정으로 시작하기",
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "현재 개발중인 기능입니다.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSocialButton(
                        icon: const Icon(
                          Icons.smartphone,
                          size: 22,
                          color: Color(0xFF1877F2),
                        ),
                        label: "전화 인증으로 시작하기",
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "현재 개발중인 기능입니다.",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
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
      ),
    );
  }

  // 소셜 로그인 버튼 공통 위젯
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
