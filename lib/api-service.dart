import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final String baseUrl = "https://learncode.biz.id/api";

  // ===========================
  // LOGIN
  // ===========================
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    final json = jsonDecode(response.body);
    print(json);

    if (response.statusCode == 200 && json["success"] == true) {
      final user = json["data"];

      return {
        "token": json["token"],
        "userId": user["id_user"],
        "nama": user["nama"],
        "username": user["username"],
        "role": user["role"],
      };
    } else {
      throw Exception(json["message"] ?? "Login gagal");
    }
  }

  // ===========================
  // LOGOUT
  // ===========================
  Future<void> logout(String token) async {
    final url = Uri.parse("$baseUrl/logout");
    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Gagal logout");
    }
  }

  // ===========================
  // GET USER PROFILE
  // ===========================
  Future<Map<String, dynamic>> getUserProfile(String token) async {
    final url = Uri.parse("$baseUrl/profile");

    final res = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("PROFILE STATUS: ${res.statusCode}");
    print("PROFILE BODY: ${res.body}");

    if (res.headers["content-type"]?.contains("text/html") == true) {
      throw Exception("Token tidak valid! Server mengembalikan HTML.");
    }

    final data = jsonDecode(res.body);

    if (res.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Gagal mengambil profil");
    }
  }

  // ===========================
  // UPDATE PROFILE
  // ===========================
  Future<Map<String, dynamic>> updateUserProfile(
      String token, String nama, String username, String kontak) async {
    final url = Uri.parse("$baseUrl/profile/update");

    final res = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
      body: {
        "nama": nama,
        "username": username,
        "kontak": kontak,
      },
    );

    print("UPDATE STATUS: ${res.statusCode}");
    print("UPDATE BODY: ${res.body}");

    if (res.headers["content-type"]?.contains("text/html") == true) {
      throw Exception(
          "Route update tidak ditemukan! Server mengembalikan HTML.");
    }

    final data = jsonDecode(res.body);

    if (res.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Gagal update profil");
    }
  }

  // ===========================
  // GET ALL PRODUCTS
  // ===========================
  Future<List> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products"));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception("Gagal memuat produk");
    }
  }

  // ===========================
  // PRODUCT BY CATEGORY
  // ===========================
  Future<List> getProductsByCategoryId(String idKategori) async {
    final url = Uri.parse("$baseUrl/products/category/$idKategori");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["data"];
    } else {
      throw Exception("Gagal memuat produk kategori id $idKategori");
    }
  }

  // ===========================
  // GET CATEGORIES
  // ===========================
  Future<List> getCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["data"];
    } else {
      throw Exception("Gagal memuat kategori");
    }
  }

  // ===========================
  // GET STORES
  // ===========================
  Future<List> getStores() async {
    final url = Uri.parse("$baseUrl/stores");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["data"];
    } else {
      throw Exception("Gagal memuat daftar toko");
    }
  }

  Future<Map<String, dynamic>?> getMyStore(String token) async {
    final url = Uri.parse("$baseUrl/stores");
    final res = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["data"];
    } else {
      throw Exception("Gagal memuat toko user");
    }
  }

  // ===========================
  // SAVE PRODUCT
  // ===========================
  Future<Map<String, dynamic>> saveProduct({
    required String namaProduk,
    required String deskripsi,
    required int harga,
    required int stok,
    required int idKategori,
    String? token,
  }) async {
    final url = Uri.parse("$baseUrl/products/save");

    String? authToken = token;

    if (authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');
      if (authToken == null) {
        throw Exception("Token tidak tersedia");
      }
    }

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({
        "nama_produk": namaProduk,
        "deskripsi": deskripsi,
        "harga": harga,
        "stok": stok,
        "id_kategori": idKategori,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data["success"] == true) {
        return data["data"];
      } else {
        throw Exception(data["message"] ?? "Gagal menyimpan produk");
      }
    } else {
      throw Exception("Gagal menyimpan produk, status code: ${res.statusCode}");
    }
  }

  // ===========================
  // DELETE PRODUCT
  // ===========================
  Future<bool> deleteProduct(int idProduk, String token) async {
    final url = Uri.parse("$baseUrl/products/$idProduk/delete");

    final res = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("RESPON DELETE: ${res.body}");

    if (res.headers["content-type"]?.contains("text/html") == true) {
      print("⚠ Server balik HTML → kemungkinan route tidak ada.");
      return false;
    }

    try {
      final data = jsonDecode(res.body);
      return data["success"] == true;
    } catch (e) {
      print("⚠ JSON Error: $e");
      return false;
    }
  }

  // ===========================
  // SEARCH PRODUCTS
  // ===========================
  Future<List> searchProducts(String keyword) async {
    final url = Uri.parse("$baseUrl/products/search?keyword=$keyword");

    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    return jsonData["data"] ?? [];
  }

  // ===========================
  // PRODUCT BY STORE
  // ===========================
  Future<List> getMyStoreProducts(String token) async {
    final url = Uri.parse("$baseUrl/stores/products");

    final res = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("RAW PRODUK TOKO: ${res.body}");

    if (res.headers["content-type"]?.contains("text/html") == true) {
      print("⚠ API mengirim HTML");
      return [];
    }

    try {
      final data = jsonDecode(res.body);

      if (data["success"] == false) {
        print("⚠ API error: ${data["message"]}");
        return [];
      }

      if (data["data"] != null && data["data"]["produk"] != null) {
        return data["data"]["produk"];
      }

      return [];
    } catch (e) {
      print("⚠ JSON decode error: $e");
      return [];
    }
  }

  // ===========================
  // UPDATE PRODUCT
  // ===========================
  Future<bool> updateProduct({
    required String token,
    required int idProduk,
    required String namaProduk,
    required int idKategori,
    required String deskripsi,
    required int harga,
    required int stok,
  }) async {
    final url = Uri.parse("$baseUrl/products/save");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "id_produk": idProduk,
        "nama_produk": namaProduk,
        "id_kategori": idKategori,
        "deskripsi": deskripsi,
        "harga": harga,
        "stok": stok,
      }),
    );

    print("UPDATE STATUS: ${response.statusCode}");
    print("UPDATE BODY: ${response.body}");

    if (response.headers["content-type"]?.contains("text/html") == true) {
      return false;
    }

    try {
      final data = jsonDecode(response.body);
      return data["success"] == true;
    } catch (e) {
      print("JSON ERROR: $e");
      return false;
    }
  }

  // ===========================
  // NORMALIZER
  // ===========================
  Map<String, dynamic> normalizeProduct(Map<String, dynamic> p) {
    return {
      "id_produk": int.tryParse(
              p["id_produk"]?.toString() ?? p["id"]?.toString() ?? "0") ??
          0,
      "nama_produk": p["nama_produk"] ?? p["nama"] ?? "",
      "harga": int.tryParse(p["harga"]?.toString() ?? "0") ?? 0,
      "stok": int.tryParse(p["stok"]?.toString() ?? "0") ?? 0,
      "deskripsi": p["deskripsi"] ?? "",
      "id_kategori": int.tryParse(p["id_kategori"]?.toString() ??
              p["kategori_id"]?.toString() ??
              "0") ??
          0,
      "gambar": p["gambar"] ?? p["image"] ?? "",
    };
  }
}
