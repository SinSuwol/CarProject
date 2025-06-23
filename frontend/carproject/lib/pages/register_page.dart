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

  // 중복확인 상태
  bool isUsernameChecked = false;
  String usernameCheckMessage = "";
  Color usernameCheckColor = Colors.grey;

  bool isValidPassword(String pw) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*])[A-Za-z\d!@#\$%^&*]{8,}$');
    return regex.hasMatch(pw);
  }

  Future<void> checkUsername() async {
    if (_username.text.isEmpty) {
      setState(() {
        usernameCheckMessage = "아이디를 입력해주세요.";
        usernameCheckColor = Colors.red;
        isUsernameChecked = false;
      });
      return;
    }

    final url = Uri.parse('http://localhost:8090/check-username?username=${_username.text}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['available'] == true) {
        setState(() {
          usernameCheckMessage = "사용 가능한 아이디입니다.";
          usernameCheckColor = Colors.green;
          isUsernameChecked = true;
        });
      } else {
        setState(() {
          usernameCheckMessage = "이미 존재하는 아이디입니다.";
          usernameCheckColor = Colors.red;
          isUsernameChecked = false;
        });
      }
    } else {
      setState(() {
        usernameCheckMessage = "서버 오류로 확인 실패";
        usernameCheckColor = Colors.red;
        isUsernameChecked = false;
      });
    }
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

    if (!isUsernameChecked) {
      setState(() {
        message = "아이디 중복 확인을 해주세요.";
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
        message = "비밀번호는 8자 이상, 영문/숫자/특수문자를 포함해야 합니다.";
        messageColor = Colors.red;
      });
      return;
    }

    final url = Uri.parse('http://192.168.0.5:8090:register');
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

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscure = false, bool isConfirm = false}) {
    final isObscure =
    obscure ? (isConfirm ? _obscureConfirm : _obscurePassword) : false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.deepOrangeAccent),
          ),
          suffixIcon: obscure
              ? IconButton(
            icon: Icon(
              isObscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("회원가입"),
        backgroundColor: const Color(0xFF1F2A3C),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              "드림카 회원가입",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            /// 아이디 + 중복확인 버튼
            Row(
              children: [
                Expanded(child: buildTextField("아이디", _username)),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: checkUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                  ),
                  child: const Text("중복확인"),
                ),
              ],
            ),
            if (usernameCheckMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(usernameCheckMessage,
                    style: TextStyle(color: usernameCheckColor)),
              ),

            buildTextField("비밀번호", _password, obscure: true),
            buildTextField("비밀번호 확인", _confirmPassword,
                obscure: true, isConfirm: true),
            buildTextField("이름", _name),
            buildTextField("이메일", _email),
            buildTextField("전화번호", _phone),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: register,
              child: const Text("회원가입"),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: messageColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
