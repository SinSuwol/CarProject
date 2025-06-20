import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPage extends StatefulWidget {
  const MyPage({super.key});
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String username = "";
  String email = "";
  String role = "";
  String message = "";

  Future<void> fetchMyInfo() async {
    //실제론 SharedPreferences 등에서 토큰을 불러와야 합니다.
    final token = 'YOUR_ACCESS_TOKEN_HERE'; // 실제 토큰으로 교체

    final res = await http.get(
      Uri.parse('http://10.0.2.2:8090/mypage'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        username = data['username'];
        email = data['email'];
        role = data['role'];
      });
    } else {
      setState(() {
        message = "인증 실패: ${res.body}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("마이페이지")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("아이디: $username"),
            Text("이메일: $email"),
            Text("권한: $role"),
            if (message.isNotEmpty) Text(message),
          ],
        ),
      ),
    );
  }
}
