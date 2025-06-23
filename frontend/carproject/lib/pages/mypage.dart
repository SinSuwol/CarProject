import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginAndFetch();
  }

  Future<void> _checkLoginAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _moveToLogin("로그인이 필요합니다.");
      return;
    }

    try {
      final res = await http.get(
        Uri.parse('http://192.168.0.5:8090/mypage'),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          username = data['username'] ?? '';
          email = data['email'] ?? '';
          role = data['role'] ?? '';
          isLoading = false;
        });
      } else {
        _moveToLogin("세션이 만료되었습니다.");
      }
    } catch (e) {
      _moveToLogin("오류 발생: ${e.toString()}");
    }
  }

  void _moveToLogin(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 16, color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A3C),
        title: const Text("마이페이지", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("내 정보",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 30),
            buildInfoCard("아이디", username),
            buildInfoCard("이메일", email),
            buildInfoCard("권한", role),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
