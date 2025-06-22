import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_page.dart';
import 'register_page.dart';
import 'mypage.dart';
import 'chat_page.dart';
import 'admin_dashboard_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  bool isLoading = true;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> localImages = [
    'assets/bennnar1.png',
    'assets/bennnar2.png',
    'assets/bennnar3.png',
  ];

  @override
  void initState() {
    super.initState();
    _checkState();
    _autoSlide();
  }

  Future<void> _checkState() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');
    setState(() {
      isLoggedIn = token != null;
      isAdmin = role == 'ADMIN';
      isLoading = false;
    });
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % localImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage = nextPage);
        _autoSlide();
      }
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _checkState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A3C),
        title: const Text(
          '드림카 - 자동차 상담 시스템',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (!isLoggedIn) ...[
            _navButton("로그인", const LoginPage()),
            _navButton("회원가입", const RegisterPage()),
          ] else ...[
            if (isAdmin)
              _navButton("관리자페이지", const AdminDashboardPage())
            else
              _navButton("마이페이지", const MyPage()),
            TextButton(
              onPressed: _logout,
              child: const Text("로그아웃", style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLocalSlider(),
            const SizedBox(height: 32),
            _buildHeroText(),
            const SizedBox(height: 40),
            _buildMainButton(),
          ],
        ),
      ),
    );
  }

  Widget _navButton(String label, Widget page) {
    return TextButton(
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildLocalSlider() {
    return Column(
      children: [
        SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            itemCount: localImages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                color: const Color(0xFF1C1C1C),
                child: Image.asset(
                  localImages[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: localImages.length,
          effect: WormEffect(
            activeDotColor: Colors.deepOrangeAccent,
            dotColor: Colors.grey,
            dotHeight: 10,
            dotWidth: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroText() {
    return Column(
      children: const [
        Text(
          '당신의 드림카,\n윤카에서 시작하세요',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Text(
          '신차·렌트 상담을 손쉽게 받고,\n전문가의 도움으로 합리적인 선택을 하세요.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMainButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () async {
        if (!isLoggedIn) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
          return;
        }

        if (isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
          );
        } else {
          final prefs = await SharedPreferences.getInstance();
          final username = prefs.getString('username') ?? 'unknown';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPage(
                roomId: '${username}_admin',
                isAdmin: false,
              ),
            ),
          );
        }
      },
      child: Text(isAdmin ? '상담 대시보드 열기' : '1:1 실시간 상담사 찾기'),
    );
  }
}
