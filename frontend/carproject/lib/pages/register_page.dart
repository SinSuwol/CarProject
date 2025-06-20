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
  Color messageColor = Colors.red;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool isValidPassword(String pw) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,}$');
    return regex.hasMatch(pw);
  }

  Future<void> register() async {
    if (_username.text.isEmpty ||
        _password.text.isEmpty ||
        _confirmPassword.text.isEmpty ||
        _name.text.isEmpty ||
        _email.text.isEmpty ||
        _phone.text.isEmpty) {
      setState(() {
        message = "모든 항목을 입력해주세요.";
        messageColor = Colors.red;
      });
      return;
    }

    if (_password.text != _confirmPassword.text) {
      setState(() {
        message = "비밀번호가 일치하지 않습니다.";
        messageColor = Colors.red;
      });
      return;
    }

    if (!isValidPassword(_password.text)) {
      setState(() {
        message = "비밀번호는 8자 이상, 영문/숫자/특수문자 포함해야 합니다.";
        messageColor = Colors.red;
      });
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
      setState(() {
        message = "회원가입 성공!";
        messageColor = Colors.green;
      });
    } else {
      setState(() {
        message = "회원가입 실패!";
        messageColor = Colors.red;
      });
    }
  }

  Widget buildTextField(String label, TextEditingController controller, {bool obscure = false, bool isConfirm = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure ? (isConfirm ? _obscureConfirm : _obscurePassword) : false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: obscure
              ? IconButton(
            icon: Icon(
              (isConfirm ? _obscureConfirm : _obscurePassword)
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                if (isConfirm) {
                  _obscureConfirm = !_obscureConfirm;
                } else {
                  _obscurePassword = !_obscurePassword;
                }
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("회원가입")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            buildTextField("아이디", _username),
            buildTextField("비밀번호", _password, obscure: true),
            buildTextField("비밀번호 확인", _confirmPassword, obscure: true, isConfirm: true),
            buildTextField("이름", _name),
            buildTextField("이메일", _email),
            buildTextField("전화번호", _phone),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("회원가입")),
            const SizedBox(height: 20),
            Text(message, style: TextStyle(color: messageColor)),
          ],
        ),
      ),
    );
  }
}
