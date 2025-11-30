import 'package:final_project/api-service.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiServices();

  String namaProduk = '';
  String deskripsi = '';
  String harga = '';
  String stok = '';
  String? selectedCategoryId;

  List categories = [];
  bool loadingCategories = true;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await api.getCategories();
      setState(() {
        categories = data;
        loadingCategories = false;
      });
    } catch (e) {
      print("Gagal load kategori: $e");
      setState(() => loadingCategories = false);
    }
  }

  Future<void> submitProduct() async {
    if (!_formKey.currentState!.validate() || selectedCategoryId == null)
      return;

    setState(() => submitting = true);
    _formKey.currentState!.save();

    try {
      await api.saveProduct(
        namaProduk: namaProduk,
        deskripsi: deskripsi,
        harga: int.parse(harga),
        stok: int.parse(stok),
        idKategori: int.parse(selectedCategoryId!),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!")),
      );

      Navigator.pop(context, true); // kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambahkan produk: $e")),
      );
    } finally {
      setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Tambah Produk"),
          backgroundColor: Colors.blue.shade700),
      body: loadingCategories
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Nama Produk"),
                      validator: (value) => value == null || value.isEmpty
                          ? "Nama produk wajib diisi"
                          : null,
                      onSaved: (value) => namaProduk = value!,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Deskripsi"),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty
                          ? "Deskripsi wajib diisi"
                          : null,
                      onSaved: (value) => deskripsi = value!,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Harga"),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? "Harga wajib diisi"
                          : null,
                      onSaved: (value) => harga = value!,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Stok"),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? "Stok wajib diisi"
                          : null,
                      onSaved: (value) => stok = value!,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(labelText: "Kategori"),
                      items: categories
                          .map((c) => DropdownMenuItem(
                                value: c["id_kategori"].toString(),
                                child: Text(c["nama_kategori"]),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategoryId = value),
                      validator: (value) =>
                          value == null ? "Pilih kategori" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitting ? null : submitProduct,
                      child: submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Tambah Produk"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
