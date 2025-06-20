import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';
import 'pages/index_page.dart';
import 'pages/admin_dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs  = await SharedPreferences.getInstance();
  final token  = prefs.getString('token');
  final role   = prefs.getString('role');     // "USER" | "ADMIN" | null

  // ----- 첫 화면 결정 -----------------------------------------------
  late final Widget first;
  if (token == null) {              // 로그인 안 됨 → LoginPage
    first = const LoginPage();
  } else if (role == 'ADMIN') {     // 관리자 → 대시보드
    first = const AdminDashboardPage();
  } else {                          // 일반 회원
    first = const IndexPage();
  }

  runApp(MyApp(initialPage: first));
}

class MyApp extends StatelessWidget {
  final Widget initialPage;
  const MyApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car 상담',
      debugShowCheckedModeBanner: false,
      home: initialPage,
    );
  }
}
