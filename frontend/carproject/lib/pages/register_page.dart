import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  String message = "";

  bool isValidPassword(String pw) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,}$');
    return regex.hasMatch(pw);
  }

  Future<void> register() async {
    if (_password.text != _confirmPassword.text) {
      setState(() => message = "비밀번호가 일치하지 않습니다.");
      return;
    }

    if (!isValidPassword(_password.text)) {
      setState(() => message = "비밀번호는 8자 이상, 영문/숫자/특수문자 포함해야 합니다.");
      return;
    }

    final url = Uri.parse('http://192.168.0.5:8090/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _username.text,
        'password': _password.text,
        'email': _email.text,
        'name': _name.text,
        'phone': _phone.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() => message = "회원가입 성공!");
    } else {
      setState(() => message = "회원가입 실패!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: _username, decoration: const InputDecoration(labelText: "아이디")),
            TextField(controller: _password, decoration: const InputDecoration(labelText: "비밀번호"), obscureText: true),
            TextField(controller: _confirmPassword, decoration: const InputDecoration(labelText: "비밀번호 확인"), obscureText: true),
            TextField(controller: _name, decoration: const InputDecoration(labelText: "이름")),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "이메일")),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: "전화번호")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("회원가입")),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
