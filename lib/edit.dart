import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/api-service.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final api = ApiServices();

  late TextEditingController namaC;
  late TextEditingController hargaC;
  late TextEditingController stokC;
  late TextEditingController deskripsiC;

  late int idProduk;
  late int idKategori;

  @override
  void initState() {
    super.initState();

    final p = api.normalizeProduct(widget.product);

    idProduk = p["id_produk"];
    idKategori = p["id_kategori"];

    namaC = TextEditingController(text: p["nama_produk"]);
    hargaC = TextEditingController(text: p["harga"].toString());
    stokC = TextEditingController(text: p["stok"].toString());
    deskripsiC = TextEditingController(text: p["deskripsi"]);
  }

  Future<void> saveUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Token hilang, login ulang")),
      );
      return;
    }

    bool success = await api.updateProduct(
      token: token,
      idProduk: idProduk,
      namaProduk: namaC.text,
      idKategori: idKategori,
      deskripsi: deskripsiC.text,
      harga: int.tryParse(hargaC.text) ?? 0,
      stok: int.tryParse(stokC.text) ?? 0,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Produk berhasil diperbarui")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update produk")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Produk")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaC,
              decoration: InputDecoration(labelText: "Nama Produk"),
            ),
            TextField(
              controller: hargaC,
              decoration: InputDecoration(labelText: "Harga"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stokC,
              decoration: InputDecoration(labelText: "Stok"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: deskripsiC,
              decoration: InputDecoration(labelText: "Deskripsi"),
            ),
            SizedBox(height: 30),

            /// ⭐ FIX BUTTON
            ElevatedButton(
              onPressed: saveUpdate,
              child: Text("Simpan Perubahan"),
            )
          ],
        ),
      ),
    );
  }
}
