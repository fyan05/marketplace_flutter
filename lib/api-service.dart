import "dart:convert";
import "package:http/http.dart" as http;

class ApiServices {
  final String baseUrl = "https://learncode.biz.id/api";

  // LOGIN
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return {
        "token": data["token"],
        "user": data["data"],
      };
    } else {
      throw Exception(data["message"] ?? "Login gagal");
    }
  }
}
