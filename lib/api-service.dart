import 'dart:convert'; // Digunakan untuk encode/decode data JSON
import 'package:http/http.dart'
    as http; // Package untuk melakukan HTTP request (GET, POST, DELETE, dsb.)
import 'produk.dart'; // Import model Product
import 'kategori.dart'; // Import model Category

// Kelas ApiServices berisi semua fungsi untuk berkomunikasi dengan API
class ApiServices {
  final String baseUrl =
      "https://learncode.biz.id/api"; // Base URL API yang digunakan untuk semua endpoint

  //---------------------------------------
  // =========== LOGIN =====================
  //---------------------------------------
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Membuat request POST untuk login
    final response = await http.post(
      Uri.parse("$baseUrl/login"), // Endpoint login
      headers: {
        "Content-Type": "application/json"
      }, // Header, menandakan body berbentuk JSON
      body: jsonEncode({
        // Body dikirim dalam format JSON
        "username": username,
        "password": password,
      }),
    );

    final data =
        jsonDecode(response.body); // Mengubah JSON response menjadi Map

    // Mengecek apakah login berhasil (status 200 dan ada token)
    if (response.statusCode == 200 &&
        (data["success"] == true || data["token"] != null)) {
      // Mengembalikan token dan data user
      return {
        "token": data["token"],
        "user": data["data"],
      };
    } else {
      // Jika gagal, lempar exception dengan pesan error
      throw Exception(data["message"] ?? "Login gagal");
    }
  }

  //---------------------------------------
  // ========== GET PROFILE ================
  //---------------------------------------
  Future<Map<String, dynamic>> getProfile(String token) async {
    // Request GET untuk mendapatkan data profil user
    final response = await http.get(
      Uri.parse("$baseUrl/profile"), // Endpoint profile
      headers: {
        "Authorization": "Bearer $token", // Mengirim token untuk otentikasi
      },
    );

    if (response.statusCode == 200) {
      // Jika berhasil, ambil data profile
      return jsonDecode(response.body)["data"];
    } else {
      // Jika gagal, lempar exception
      throw Exception("Gagal memuat profil");
    }
  }

  //---------------------------------------
  // ========== GET CATEGORIES =============
  //---------------------------------------
  Future<List<Category>> getCategories() async {
    // Request GET untuk mengambil daftar kategori
    final response = await http.get(Uri.parse("$baseUrl/categories"));

    if (response.statusCode == 200) {
      // Ambil data dari JSON
      List data = jsonDecode(response.body)["data"];
      // Ubah setiap item menjadi object Category
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      // Jika gagal, lempar exception
      throw Exception("Gagal memuat kategori");
    }
  }

  //---------------------------------------
  // ========== GET PRODUCTS ==============
  //---------------------------------------
  Future<List<Product>> getProducts() async {
    // Request GET untuk mengambil daftar produk
    final res = await http.get(Uri.parse("$baseUrl/products"));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body); // Decode JSON
      final List data = body["data"]; // Ambil list produk
      // Ubah setiap item menjadi object Product
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      print(res.body); // Print response jika gagal untuk debugging
      throw Exception("Gagal load server");
    }
  }

  //---------------------------------------
  // ========== CREATE PRODUCT ============
  //---------------------------------------
  Future<bool> createProduct({
    required String name,
    required int price,
    required int categoryId,
    required String image,
  }) async {
    // Request POST untuk membuat produk baru
    final response = await http.post(
      Uri.parse("$baseUrl/products/save"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nama_produk": name,
        "harga": price
            .toString(), // Mengubah harga ke string karena API mungkin menerima string
        "id_kategori": categoryId.toString(),
        "deskripsi": "", // Default kosong
        "stok": "1", // Default 1
        "images": image.isNotEmpty ? [image] : [], // Jika ada image, buat list
      }),
    );

    print(
        "CREATE RESPONSE: ${response.body}"); // Debugging: lihat response dari server

    final body = jsonDecode(response.body);

    // Mengembalikan true jika create berhasil
    return body["success"] == true;
  }

  //---------------------------------------
  // ========== UPDATE PRODUCT ============
  //---------------------------------------
  Future<bool> updateProduct({
    required int id,
    required String name,
    required int price,
    required int categoryId,
    required String image,
  }) async {
    // Request POST untuk update produk
    final response = await http.post(
      Uri.parse("$baseUrl/products/save"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id_produk": id, // ID produk wajib ada untuk update
        "nama_produk": name,
        "harga": price.toString(),
        "id_kategori": categoryId.toString(),
        "deskripsi": "",
        "stok": "1",
        "images": image.isNotEmpty ? [image] : [],
      }),
    );

    print("UPDATE RESPONSE: ${response.body}"); // Debugging

    final body = jsonDecode(response.body);

    // Mengembalikan true jika update berhasil
    return body["success"] == true;
  }

  //---------------------------------------
  // ========== DELETE PRODUCT ============
  //---------------------------------------
  Future<bool> deleteProduct(int id) async {
    // Request DELETE untuk menghapus produk berdasarkan ID
    final response = await http.delete(
      Uri.parse("$baseUrl/products/$id"),
    );

    // Mengembalikan true jika status 200
    return response.statusCode == 200;
  }
}
