import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  final String token;

  const CategoryPage({super.key, required this.token});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categories = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse("https://learncode.biz.id/api/categories"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${widget.token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories =
            (data['data'] as List).map((e) => Category.fromJson(e)).toList();
        loading = false;
      });
    } else {
      print("Gagal memuat kategori: ${response.body}");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori"),
        backgroundColor: Colors.green,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final c = categories[index];
                return Card(
                  child: ListTile(
                    title: Text(c.name),
                  ),
                );
              },
            ),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id_kategori'], // langsung int, sudah benar
      name: json['nama_kategori'] ?? '', // string aman
    );
  }
}
