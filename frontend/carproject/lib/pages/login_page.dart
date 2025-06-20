import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'index_page.dart';
import 'register_page.dart';

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
    if (data['success'] == true && data['accessToken'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['accessToken']);
      await prefs.setString('username', _id.text);
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const IndexPage()));
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
            TextField(controller: _id, decoration: const InputDecoration(labelText: '아이디')),
            TextField(controller: _pw, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('로그인')),
            const SizedBox(height: 20),
            Text(msg, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: const Text('계정이 없으신가요? 회원가입하기')),
          ],
        ),
      ),
    );
  }
}
