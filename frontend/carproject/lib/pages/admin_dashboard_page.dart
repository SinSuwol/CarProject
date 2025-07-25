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

  Future<void> _fetchRooms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
        return;
      }

      final res = await http.get(
        Uri.parse('http://192.168.0.5:8090/chat/rooms'),
        headers: {'Authorization': 'Bearer $token'},
      );

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
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('방 목록 조회 실패: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          '상담 대기 목록 (관리자)',
          style: TextStyle(
            color: Color(0xFFFF6D00),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: '새로고침',
            onPressed: () {
              setState(() => loading = true);
              _fetchRooms();
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            tooltip: '메인으로',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
            icon: const Icon(Icons.home_outlined, color: Colors.white),
          ),
          IconButton(
            tooltip: '로그아웃',
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF6D00),
          strokeWidth: 4,
        ),
      )
          : rooms.isEmpty
          ? const Center(
        child: Text(
          '현재 대기 중인 회원이 없습니다',
          style: TextStyle(color: Colors.white70),
        ),
      )
          : ListView.separated(
        itemCount: rooms.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: Colors.grey,
        ),
        itemBuilder: (_, i) {
          final user = rooms[i];
          return ListTile(
            tileColor: const Color(0xFF1E1E1E),
            leading: const Icon(Icons.person_outline,
                color: Colors.white70),
            title: Text(
              '회원: $user',
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.chat_bubble_outline,
                color: Color(0xFFFF6D00)),
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
