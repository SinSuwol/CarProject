import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carproject/pages/index_page.dart';
import 'package:carproject/pages/register_page.dart'; // 추가
import 'package:carproject/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String message = "";

  Future<void> login() async {
    final data = await ApiService.login(_idController.text, _pwController.text);

    if (data['success'] == true && data['accessToken'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['accessToken']);
      await prefs.setString('username', _idController.text); // sender용

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IndexPage()),
      );
    } else {
      setState(() {
        message = "로그인 실패: ${data['message'] ?? '서버 오류'}";
      });
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
              controller: _idController,
              decoration: const InputDecoration(labelText: "아이디"),
            ),
            TextField(
              controller: _pwController,
              decoration: const InputDecoration(labelText: "비밀번호"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("로그인")),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("계정이 없으신가요? 회원가입하기"),
            ),
          ],
        ),
      ),
    );
  }
}
