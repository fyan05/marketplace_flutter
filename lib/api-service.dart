import "dart:convert";
import "package:http/http.dart" as http;

class ApiServices {
  final String baseUrl = "https://dummyjson.com";

  // LOGIN
  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['accessToken'] == null) ;
      return data['accessToken']; // sukses -> ambil token
    } else {
      throw Exception(data["message"] ?? 'Failed to login');
    }
  }

  // GET USER PROFILE
  Future<Map<String, dynamic>> getUserProfile(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // langsung return object user
    } else {
      throw Exception('Failed to load user');
    }
  }
}
