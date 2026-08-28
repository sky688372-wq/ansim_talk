import 'dart:async';
import 'dart:convert';

import 'package:ansim_talk/introduce/intro_manage_screen.dart';
import 'package:ansim_talk/login/register_screen.dart';
import 'package:ansim_talk/login/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:http/http.dart' as http;
import 'package:ansim_talk/user_model/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}




class _LoginScreenState extends State<LoginScreen> {
  static const Color _brandGreen = Color(0xFF639922);
  static const Color _brandGreenDark = Color(0xFF27500A);
  static const Color _brandGreenLight = Color(0xFFEAF3DE);

  // 입력 컨트롤러
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  // 상태 관리 변수
  bool _passwordIsShow = false;
  bool _rememberMe = false; // 로그인 상태 유지 체크박스 -> 실제
  bool _isLoggingIn = false;

  Future<void> _login() async {
    if (_isLoggingIn) return;

    final loginId = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final url = Uri.parse('http://210.114.17.158:8000/api/v1/auth/login');

    if (loginId.isEmpty || password.isEmpty) {
      _showSnackBar('아이디와 비밀번호를 입력해 주세요.');
      return;
    }

    setState(() => _isLoggingIn = true);

    try {
      print('[LoginScreen] 로그인 요청 시작: $url, loginId=$loginId');
      final response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'login_id': loginId,
          'password': password,
        }),
      )
          .timeout(const Duration(seconds: 15));

      // access_token이 포함될 수 있으므로 response.body 전체는 로그에 출력하지 않음
      print('[LoginScreen] HTTP 상태 코드: ${response.statusCode}');

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map) {
        throw const FormatException('로그인 응답이 JSON 객체 형식이 아닙니다.');
      }
      final body = Map<String, dynamic>.from(decoded);
      print('[LoginScreen] success 값: ${body['success']}');

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          body['success'] == true) {
        final rawData = body['data'];
        if (rawData is! Map) {
          throw const FormatException('로그인 응답에 data 객체가 없습니다.');
        }
        final responseData = Map<String, dynamic>.from(rawData);
        final rawUser = responseData['user'];
        final accessToken = responseData['access_token'] as String? ?? '';

        if (rawUser is! Map || accessToken.isEmpty) {
          print('[LoginScreen] user 객체 또는 access_token이 비어 있습니다.');
          throw const FormatException('로그인 응답에 사용자 정보 또는 access_token이 없습니다.');
        }

        final userData = Map<String, dynamic>.from(rawUser);
        final userId = (userData['id'] as num?)?.toInt() ?? 0;

        if (userId <= 0) {
          throw const FormatException('로그인 응답에 사용자 ID가 없습니다.');
        }

        // 전역 변수에 저장하지 않고 UserSession에 사용자 정보를 저장한다. -> 정보 공용으로 사용하려고 인스턴스화 함
        UserSession().setUserInfo(
          userId: userId,
          name: userData['name'] as String? ?? '',
          profileImage: userData['profile_image'] as String? ?? '',
          token: accessToken,
        );
        print('[LoginScreen] UserSession 저장 후 토큰 존재 여부: ${UserSession().token.isNotEmpty}, 길이: ${UserSession().token.length}');

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IntroManageScreen()),
        );
      } else {
        final message = _extractApiErrorMessage(body);
        print('[LoginScreen] 로그인 실패: $message');

        if (!mounted) return;
        _showSnackBar(message);
      }
    } catch (error, stackTrace) {
      print('[LoginScreen] 로그인 오류: $error');
      print('[LoginScreen] stackTrace:\n$stackTrace');

      if (!mounted) return;
      _showSnackBar(_getFriendlyErrorMessage(error));
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
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
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFDDEDC7),
              Color(0xFFF8FBF4),
              Color(0xFFF7F9F5),
            ],
            stops: <double>[0, 0.42, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                const Spacer(flex: 2),
                _buildBrandHeader(),
                const Spacer(),
                _buildLoginCard(context),
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

  Widget _buildBrandHeader() {
    return Column(
      children: <Widget>[
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _brandGreen,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: _brandGreen.withValues(alpha: 0.22),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/logo/app_icon.png',
              color: Colors.white,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '안심톡',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            color: _brandGreenDark,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
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
            '로그인',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: _brandGreenDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '등록된 계정으로 안전하게 접속하세요.',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const Text(
            '아이디',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brandGreenDark),
          ),
          const SizedBox(height: 6),
          _buildInputField(
            controller: _emailCtrl,
            hintText: '아이디를 입력해주세요',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          const Text(
            '비밀번호',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _brandGreenDark),
          ),
          const SizedBox(height: 6),
          _buildInputField(
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      activeColor: _brandGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('로그인 유지', style: TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: _brandGreenDark),
                child: const Text('비밀번호 찾기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoggingIn ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: _brandGreen,
                foregroundColor: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('로그인', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildSocialButton(
                  icon: const Icon(SimpleIcons.google, size: 18, color: SimpleIconColors.google),
                  label: '구글',
                  onTap: () => _showDevelopingMessage(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSocialButton(
                  icon: const Icon(Icons.smartphone, size: 19, color: Color(0xFF1877F2)),
                  label: '전화번호',
                  onTap: () => _showDevelopingMessage(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              style: TextButton.styleFrom(foregroundColor: _brandGreenDark),
              child: const Text(
                '계정이 없으신가요?  회원가입',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 52,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: _brandGreenDark, size: 23),
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
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 44,
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

  String _extractApiErrorMessage(Map<String, dynamic> body) {
    final error = body['error'];
    if (error is Map && error['message'] != null) {
      return error['message'].toString();
    }
    if (body['message'] != null) return body['message'].toString();
    if (body['detail'] != null) return body['detail'].toString();
    return '아이디 또는 비밀번호를 확인해 주세요.';
  }

  String _getFriendlyErrorMessage(Object error) {
    if (error is TimeoutException) {
      return '서버 응답이 늦습니다. 잠시 후 다시 시도해 주세요.';
    }
    if (error is FormatException) {
      return '로그인 응답을 확인할 수 없습니다. 관리자에게 문의해 주세요.';
    }
    return '로그인 중 문제가 발생했습니다. 네트워크 연결을 확인해 주세요.';
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
          duration: const Duration(seconds: 3),
        ),
      );
  }

  void _showDevelopingMessage(BuildContext context) {
    _showSnackBar('현재 개발 중인 기능입니다.');
  }
}