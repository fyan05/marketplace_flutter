import 'package:flutter/material.dart';
import 'api-service.dart';
import 'produk.dart';
import 'kategori.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({this.product, super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final ApiServices api = ApiServices();

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final imageC = TextEditingController();

  int? selectedCategory;
  late Future<List<Category>> categoryFuture;

  @override
  void initState() {
    super.initState();
    categoryFuture = api.getCategories();

    if (widget.product != null) {
      nameC.text = widget.product!.name;
      priceC.text = widget.product!.price.toString();
      imageC.text = widget.product!.image;
      selectedCategory = widget.product!.categoryId;
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    priceC.dispose();
    imageC.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (nameC.text.isEmpty || priceC.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Isi semua data")));
      return;
    }

    bool success = false;

    try {
      if (widget.product == null) {
        success = await api.createProduct(
          name: nameC.text,
          price: int.parse(priceC.text),
          categoryId: selectedCategory!,
          image: imageC.text,
        );
      } else {
        success = await api.updateProduct(
          id: widget.product!.id,
          name: nameC.text,
          price: int.parse(priceC.text),
          categoryId: selectedCategory!,
          image: imageC.text,
        );
      }
    } catch (e) {
      success = false;
    }

    if (success && mounted) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal simpan")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.product == null ? "Tambah Produk" : "Edit Produk")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceC,
              decoration: const InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: imageC,
              decoration: const InputDecoration(labelText: "URL Gambar"),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Category>>(
              future: categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Gagal memuat kategori: ${snapshot.error}");
                }

                final categories = snapshot.data ?? [];

                return DropdownButtonFormField<int>(
                  value: selectedCategory,
                  hint: const Text("Pilih Kategori"),
                  items: categories.map((c) {
                    return DropdownMenuItem<int>(
                      value: c.id,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProduct,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
