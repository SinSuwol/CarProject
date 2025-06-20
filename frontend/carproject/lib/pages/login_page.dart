import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('http://localhost:8090/login'); // 실제 서버 주소로 교체 필요
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _idController.text,
        'password': _pwController.text,
      }),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      setState(() {
        message = "로그인 성공! 사용자: ${data['username']}";
      });

      // ✅ 이후: 토큰 저장 (SharedPreferences 등)
      // ✅ Navigator.push(...)로 메인 페이지 이동

    } else {
      setState(() {
        message = "로그인 실패: ${data['message']}";
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
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "아이디")),
            TextField(controller: _pwController, decoration: const InputDecoration(labelText: "비밀번호"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("로그인")),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
