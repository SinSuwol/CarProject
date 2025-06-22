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

  // ✅ Spring 서버가 실행 중인 PC의 IP로 고정
  static const springServerIp = '192.168.45.5';
  static final wsUrl   = 'ws://$springServerIp:8090/ws/chat';
  static final apiBase = 'http://$springServerIp:8090';

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  Future<void> _connectToWebSocket() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final myId  = prefs.getString('username');

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("상담방 - ${widget.roomId}")),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('메시지가 없습니다'))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _send, child: const Text("보내기")),
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
    final time = (msg['timestamp'] ?? '').toString().split(' ').lastOrNull ?? '';

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: mine ? Colors.orange.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
          mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text),
            const SizedBox(height: 4),
            Text(
              time.length >= 5 ? time.substring(0, 5) : '',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
