import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_page.dart';
import 'login_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<String> rooms = [];
  bool loading = true;

  //------------------------------------------------------------------ init
  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  //------------------------------------------------------------------ REST
  Future<void> _fetchRooms() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
      return;
    }

    final res = await http.get(
      Uri.parse('http://192.168.0.5:8090/chat/rooms'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      setState(() {
        rooms = List<String>.from(jsonDecode(res.body));
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('방 목록 조회 실패: ${res.statusCode}')));
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false);
  }

  //------------------------------------------------------------------ UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상담 대기 목록 (관리자)'),
        actions: [
          IconButton(
              tooltip: '새로고침',
              onPressed: () {
                setState(() => loading = true);
                _fetchRooms();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              tooltip: '로그아웃',
              onPressed: _logout,
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : rooms.isEmpty
          ? const Center(child: Text('현재 대기 중인 회원이 없습니다'))
          : ListView.separated(
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final user = rooms[i];
          return ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text('회원: $user'),
            trailing: const Icon(Icons.chat_bubble_outline),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChatPage(roomId: user, isAdmin: true),
              ),
            ),
          );
        },
      ),
    );
  }
}
