import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/index_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');          // 토큰 유무 확인
  runApp(MyApp(initialPage: token == null ? const IndexPage() : const IndexPage()));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car 상담',
      debugShowCheckedModeBanner: false,
      home: initialPage,                           // IndexPage 고정
    );
  }
}
