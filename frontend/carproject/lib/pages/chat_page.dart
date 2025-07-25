import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final bool isAdmin;

  const ChatPage({super.key, required this.roomId, this.isAdmin = false});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final input = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late StompClient stomp;
  late String sender;
  bool loading = true;

  static const springServerIp = '192.168.0.5';
  static final wsUrl = 'ws://$springServerIp:8090/ws/chat_f';
  static final apiBase = 'http://$springServerIp:8090';

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final myId = prefs.getString('username');

    if (token == null || myId == null) {
      _showErrorAndExit("로그인이 필요합니다.");
      return;
    }

    sender = widget.isAdmin ? "admin" : myId;

    await _loadHistory(token);

    stomp = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (frame) {
          stomp.subscribe(
            destination: '/topic/room/${widget.roomId}',
            callback: (f) {
              final msg = jsonDecode(f.body!);
              setState(() => _messages.add(msg));
            },
          );
          setState(() => loading = false);
        },
        onWebSocketError: (e) => _showErrorAndExit("WebSocket 오류: $e"),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    stomp.activate();
  }

  Future<void> _loadHistory(String token) async {
    final res = await http.get(
      Uri.parse('$apiBase/chat/history/${widget.roomId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      setState(() {
        _messages.addAll(List<Map<String, dynamic>>.from(jsonDecode(res.body)));
      });
    } else {
      _showErrorAndExit("채팅 기록을 불러오지 못했습니다.");
    }
  }

  void _send() {
    final msg = input.text.trim();
    if (msg.isEmpty || !stomp.connected) return;

    stomp.send(
      destination: '/chat/chat.send/${widget.roomId}',
      body: jsonEncode({
        'roomId': widget.roomId,
        'sender': sender,
        'message': msg,
      }),
    );
    input.clear();
  }

  void _showErrorAndExit(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    if (stomp.connected) stomp.deactivate();
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6D00)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "상담방 - ${widget.roomId}",
          style: const TextStyle(color: Color(0xFFFF6D00)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
              child: Text('메시지가 없습니다',
                  style: TextStyle(color: Colors.white70)),
            )
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6D00),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: const Text("보내기", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final mine = msg['sender'] == sender;
    final text = msg['message'] ?? '';
    final timestamp = msg['timestamp'];

    String formattedTime = '';
    if (timestamp != null && timestamp is String) {
      try {
        final parsed = DateTime.parse(timestamp);
        formattedTime =
        '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        formattedTime = '';
      }
    }

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mine ? const Color(0xFFFF6D00) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
          mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: const TextStyle(fontSize: 10, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
