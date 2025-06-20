import 'dart:ui';

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'mypage.dart';
import 'chat_page.dart';

class IndexPage extends StatelessWidget{
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            //index 페이지로 이동
            Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const IndexPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            //여기에 이미지 로고 넣으면 됨.
          ),
        ),
        title: const Text(''),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            child: const Text('로그인',),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text('회원가입',),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyPage()),
              );
            },
            child: const Text('마이페이지',),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ChatPage())
              );
            },
            child: const Text('실시간 상담사 찾기'),
        ),
      ),
    );
  }
}
