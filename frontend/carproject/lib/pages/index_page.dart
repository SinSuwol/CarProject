import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'register_page.dart';
import 'mypage.dart';
import 'chat_page.dart';
import 'admin_dashboard_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoggedIn = false;
  bool isAdmin    = false;
  bool isLoading  = true;

  //---------------------------------------------------------------- init
  @override
  void initState() {
    super.initState();
    _checkState();
  }

  Future<void> _checkState() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role  = prefs.getString('role');           // USER / ADMIN
    setState(() {
      isLoggedIn = token != null;
      isAdmin    = role == 'ADMIN';
      isLoading  = false;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      isLoggedIn = false;
      isAdmin    = false;
    });
  }

  //---------------------------------------------------------------- UI
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
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text('로그인', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text('회원가입', style: TextStyle(color: Colors.white)),
            ),
          ] else ...[
            if (!isAdmin)                       // 회원 전용
              TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const MyPage())),
                child: const Text('마이페이지',
                    style: TextStyle(color: Colors.white)),
              ),
            if (isAdmin)                       // 관리자 전용
              TextButton(
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const AdminDashboardPage())),
                child: const Text('대시보드',
                    style: TextStyle(color: Colors.white)),
              ),
            TextButton(
              onPressed: _logout,
              child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),

      //---------------------------- BODY ------------------------------
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (!isLoggedIn) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
              return;
            }

            if (isAdmin) {
              // 관리자는 다이렉트로 대시보드(방 목록)로
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminDashboardPage()));
            } else {
              // 회원은 본인 방으로 입장
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatPage(
                        roomId: (SharedPreferences.getInstance()
                            .then((p) => p.getString('username'))) as String,
                        isAdmin: false,
                      )));
            }
          },
          child: Text(isAdmin ? '상담 대시보드 열기' : '실시간 상담사 찾기'),
        ),
      ),
    );
  }
}
