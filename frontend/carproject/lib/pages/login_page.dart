import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'index_page.dart';
import 'register_page.dart';
import 'admin_dashboard_page.dart';          // ★ 관리자 대시보드

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _id = TextEditingController();
  final _pw = TextEditingController();
  String msg = "";

  Future<void> _login() async {
    final data = await ApiService.login(_id.text, _pw.text);
    // data = { success, accessToken, role, message }
    if (data['success'] == true && data['accessToken'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs
        ..setString('token', data['accessToken'])
        ..setString('username', _id.text)
        ..setString('role', data['role']);                // ★ role 저장

      if (!mounted) return;
      // ★ role 에 따라 페이지 분기
      if (data['role'] == 'ADMIN') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const IndexPage()),
        );
      }
    } else {
      setState(() => msg = data['message'] ?? '로그인 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: _id,
                decoration: const InputDecoration(labelText: '아이디')),
            TextField(
                controller: _pw,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('로그인')),
            const SizedBox(height: 20),
            Text(msg, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: const Text('계정이 없으신가요? 회원가입하기')),
          ],
        ),
      ),
    );
  }
}
