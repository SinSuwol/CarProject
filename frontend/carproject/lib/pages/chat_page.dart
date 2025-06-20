import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'login_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  String roomId = "room123";
  String sender = "";
  WebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    _checkLoginAndConnect();
  }

  Future<void> _checkLoginAndConnect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');

    if (token == null || username == null) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
      return;
    }

    setState(() {
      sender = username;
    });

    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.5:8090/ws/chat'),
    );

    channel!.stream.listen((data) {
      final msg = jsonDecode(data);
      setState(() {
        _messages.add({
          "sender": msg['sender'] ?? '',
          "message": msg['message'] ?? '',
          "timestamp": msg['timestamp'] ?? '',
        });
      });
    });
  }

  void sendMessage() {
    if (_controller.text.isEmpty || sender.isEmpty || channel == null) return;

    final message = {
      "roomId": roomId,
      "sender": sender,
      "message": _controller.text,
    };

    channel!.sink.add(jsonEncode(message));
    _controller.clear();
  }

  @override
  void dispose() {
    channel?.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  Widget buildMessage(Map<String, dynamic> msg) {
    final isMe = msg['sender'] == sender;
    final bgColor = isMe ? Colors.orange[200] : Colors.grey[300];
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    )
        : const BorderRadius.only(
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: bgColor, borderRadius: radius),
          child: Text(msg['message'] ?? ''),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: Text(
            msg['timestamp'] ?? '',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("실시간 상담")),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("메시지가 없습니다"))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return buildMessage(_messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text("보내기"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
