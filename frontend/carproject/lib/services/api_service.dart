import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _base = 'http://localhost:8090';

  static Future<Map<String, dynamic>> login(String id, String pw) async {
    final res = await http.post(
      Uri.parse('$_base/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': id, 'password': pw}),
    );
    return res.statusCode == 200
        ? jsonDecode(res.body)
        : {'success': false, 'message': '서버 ${res.statusCode}'};
  }
}
