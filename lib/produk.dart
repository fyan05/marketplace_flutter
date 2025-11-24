import 'package:flutter/material.dart';
import 'api-service.dart';
import 'tambah+edit-produk.dart';

class ProductPage extends StatefulWidget {
  final String token;
  final int userId;
  const ProductPage({super.key, required this.token, required this.userId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiServices api = ApiServices();

  late Future<List<Product>> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = api.getProducts();
  }

  void refreshData() {
    setState(() {
      productFuture = api.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Produk")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          ).then((value) => refreshData());
        },
      ),
      body: FutureBuilder<List<Product>>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Gagal load server: ${snapshot.error}"));
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text("Belum ada produk"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    p.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => const Icon(Icons.broken_image),
                  ),
                  title: Text(p.name),
                  subtitle: Text("Rp ${p.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductFormPage(product: p),
                            ),
                          ).then((value) => refreshData());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final ok = await api.deleteProduct(p.id);
                          if (ok) refreshData();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Product model (jika mau dipisah, bisa buat file product_model.dart)
class Product {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;
  final int price;
  final int stock;
  final String description;
  final String date;
  final String image; // ambil gambar pertama atau kosong

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.stock,
    required this.description,
    required this.date,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List? ?? [];

    return Product(
      id: json['id_produk'],
      name: json['nama_produk'] ?? '',
      categoryId: int.parse(json['id_kategori'].toString()),
      categoryName: json['nama_kategori'] ?? '',
      price: int.parse(json['harga'].toString()),
      stock: int.parse(json['stok'].toString()),
      description: json['deskripsi'] ?? '',
      date: json['tanggal_upload'] ?? '',
      image: images.isNotEmpty ? images[0]['url']?.toString() ?? "" : "",
    );
  }
}
