import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'mypage.dart';
import 'chat_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoggedIn = false;
  bool isLoading  = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getString('token') != null;
      isLoading  = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() => isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Car 상담'),
        actions: [
          if (!isLoggedIn) ...[
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginPage())),
                child: const Text('로그인', style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: const Text('회원가입', style: TextStyle(color: Colors.white))),
          ] else ...[
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MyPage())),
                child: const Text('마이페이지', style: TextStyle(color: Colors.white))),
            TextButton(
                onPressed: _logout,
                child: const Text('로그아웃', style: TextStyle(color: Colors.white))),
          ]
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (isLoggedIn) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatPage()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            }
          },
          child: const Text('실시간 상담사 찾기'),
        ),
      ),
    );
  }
}
