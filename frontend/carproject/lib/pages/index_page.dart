import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carproject/pages/mypage.dart';
import 'package:carproject/pages/chat_page.dart';
import 'package:carproject/pages/login_page.dart';
import 'package:carproject/pages/register_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoggedIn = false;
  bool isLoading = true; // ✅ 로딩 상태 변수

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      isLoggedIn = token != null;
      isLoading = false; // ✅ 로딩 완료
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('username');
    setState(() {
      isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // ✅ 로딩 중엔 아무 것도 안 보여주고 로딩 표시
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car 상담'),
        actions: [
          if (!isLoggedIn)
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text('로그인', style: TextStyle(color: Colors.white)),
            ),
          if (!isLoggedIn)
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text('회원가입', style: TextStyle(color: Colors.white)),
            ),
          if (isLoggedIn)
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyPage())),
              child: const Text('마이페이지', style: TextStyle(color: Colors.white)),
            ),
          if (isLoggedIn)
            TextButton(
              onPressed: () => logout(context),
              child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (isLoggedIn) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatPage()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            }
          },
          child: const Text('실시간 상담사 찾기'),
        ),
      ),
    );
  }
}
