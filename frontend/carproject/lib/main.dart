import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/index_page.dart';
import 'pages/admin_dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car 상담',
      debugShowCheckedModeBanner: false,
      home: const IndexPage(), // ✅ 무조건 IndexPage로 시작
    );
  }
}
