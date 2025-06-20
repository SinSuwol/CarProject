import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'login_page.dart';

class ChatPage extends StatefulWidget {
  /// 회원은 `roomId = 본인 username`,
  /// 관리자는 상대 회원 ID 를 넘겨 줍니다.
  final String roomId;
  /// 관리자로 들어올 때 true
  final bool isAdmin;
  const ChatPage({super.key, required this.roomId, this.isAdmin = false});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final input = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  late String sender;                 // 보내는 사람 ID
  late StompClient stomp;
  bool loading = true;

  static const wsUrl = 'ws://192.168.0.5:8090/ws/chat'; // 순수 WS 엔드포인트

  //---------------------------------------------------------------- init
  @override
  void initState() {
    super.initState();
    _prepareAndConnect();
  }

  Future<void> _prepareAndConnect() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final myId  = prefs.getString('username') ?? '';

    if (token == null || myId.isEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginPage()));
      }
      return;
    }

    sender = widget.isAdmin ? 'admin' : myId;  // 관리자면 admin 고정

    // 선택사항: 입장 시 과거 대화 100건 로드
    await _loadHistory(token);

    stomp = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: _onConnect,
        onWebSocketError: (e) => _snack('WS 오류: $e'),
        onStompError   : (f) => _snack('STOMP 오류: ${f.body}'),
        // 토큰 인증이 필요하면 주석 해제
        // stompConnectHeaders: {'Authorization': 'Bearer $token'},
        // webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
    stomp.activate();
  }

  //---------------------------------------------------------------- REST – history
  Future<void> _loadHistory(String token) async {
    final url =
        'http://192.168.0.5:8090/chat/history/${widget.roomId}';
    final res = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode == 200) {
      setState(() {
        _messages.addAll(
            List<Map<String, dynamic>>.from(jsonDecode(res.body)));
      });
    }
  }

  //---------------------------------------------------------------- STOMP
  void _onConnect(StompFrame _) {
    // 구독
    stomp.subscribe(
      destination: '/topic/room/${widget.roomId}',
      callback: (frame) => setState(() {
        _messages.add(jsonDecode(frame.body!));
      }),
    );
    setState(() => loading = false);
  }

  void _send() {
    if (input.text.isEmpty) return;
    stomp.send(
      destination: '/chat/chat.send/${widget.roomId}',
      body: jsonEncode({
        'roomId' : widget.roomId,
        'sender' : sender,
        'message': input.text,
      }),
    );
    input.clear();
  }

  //---------------------------------------------------------------- utils
  void _snack(String m) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(m)));

  @override
  void dispose() {
    stomp.deactivate();
    input.dispose();
    super.dispose();
  }

  //---------------------------------------------------------------- UI
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('상담방 - ${widget.roomId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('메시지가 없습니다'))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _bubble(_messages[i]),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    decoration: const InputDecoration(
                        hintText: '메시지를 입력하세요',
                        border: OutlineInputBorder()),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _send, child: const Text('보내기')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(Map<String, dynamic> m) {
    final mine = m['sender'] == sender;
    final bg   = mine ? Colors.orange.shade200 : Colors.grey.shade300;

    final radius = mine
        ? const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12))
        : const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12));

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: bg, borderRadius: radius),
        child: Text(m['message']),
      ),
    );
  }
}
