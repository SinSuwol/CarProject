import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("http://192.168.0.5:8090/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"success": false, "message": "서버 오류: ${response.statusCode}"};
    }
  }
}
