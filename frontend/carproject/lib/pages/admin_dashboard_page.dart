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

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  // ----------------------------------------- REST API: 채팅방 목록 가져오기
  Future<void> _fetchRooms() async {
    try {
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

      print('방 목록 요청 응답 코드: ${res.statusCode}');
      print('응답 본문: ${res.body}');

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        if (decoded is List) {
          setState(() {
            rooms = List<String>.from(decoded);
            loading = false;
          });
        } else {
          throw Exception('응답 형식이 리스트가 아님');
        }
      } else {
        throw Exception('HTTP ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('방 목록 가져오기 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('방 목록 조회 실패: $e')),
        );
      }
    }
  }

  // ----------------------------------------- 로그아웃
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (_) => false);
  }

  // ----------------------------------------- UI
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
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: '로그아웃',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.deepOrangeAccent,
          strokeWidth: 4,
        ),
      )
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
