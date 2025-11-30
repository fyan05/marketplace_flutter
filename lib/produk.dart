import 'dart:convert';
import 'package:final_project/detail-produk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  final String token;
  final int userId;

  const ProductListPage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];
  bool loading = true;

  Map<String, dynamic> normalizeProduct(Map<String, dynamic> p) {
    return {
      "id_produk": p["id_produk"] ?? p["id"] ?? 0,
      "nama_produk": p["nama_produk"] ?? p["nama"] ?? "",
      "harga": p["harga"] ?? 0,
      "stok": p["stok"] ?? 0,
      "deskripsi": p["deskripsi"] ?? "",
      "nama_kategori": p["nama_kategori"] ?? p["kategori"] ?? "",
      "gambar": p["gambar"] ?? p["image"] ?? "",
    };
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse("https://learncode.biz.id/api/products");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          products = data["data"] ?? [];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      print("ERROR FETCH: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: const Text(
          "Produk",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.green.shade600,
            ))
          : products.isEmpty
              ? const Center(child: Text("Tidak ada produk"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final fixed = normalizeProduct(p);

                    final imageUrl = fixed["gambar"] != ""
                        ? "https://learncode.biz.id/storage/${fixed['gambar']}"
                        : null;

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green.shade200,
                          backgroundImage:
                              imageUrl != null ? NetworkImage(imageUrl) : null,
                        ),

                        title: Text(
                          fixed["nama_produk"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: Text(
                          "Rp ${fixed["harga"]}",
                          style: const TextStyle(fontSize: 13),
                        ),

                        // ⬇⬇⬇ CLICK KE DETAIL PRODUK
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailProdukPage(product: fixed),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
