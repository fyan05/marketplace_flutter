import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProdukPage extends StatelessWidget {
  final Map product;

  const DetailProdukPage({super.key, required this.product});

  // Format harga ribuan + null safety
  String formatHarga(dynamic harga) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    final intHarga = int.tryParse(harga?.toString() ?? "0") ?? 0;
    return formatter.format(intHarga);
  }

  // Fungsi WA
  void openWhatsApp(String message) async {
    final url = Uri.parse("https://wa.me/6285933245669?text=$message");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nama = product['nama_produk']?.toString() ?? "-";
    final harga = product['harga']?.toString() ?? "0";
    final kategori = product['nama_kategori']?.toString() ?? "-";
    final stok = product['stok']?.toString() ?? "0";
    final deskripsi = product['deskripsi']?.toString() ?? "-";

    final image = product['gambar'] != null
        ? "https://learncode.biz.id/storage/${product['gambar']}"
        : "https://via.placeholder.com/300x200?text=No+Image";

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Detail Produk", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 20),

            // NAMA
            Text(
              nama,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 10),

            // HARGA
            Text(
              "Rp ${formatHarga(harga)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),

            SizedBox(height: 20),

            // KATEGORI
            Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(kategori),

            SizedBox(height: 15),

            // STOK
            Text("Stok", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(stok),

            SizedBox(height: 15),

            // DESKRIPSI
            Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(deskripsi),

            SizedBox(height: 40),

            // TOMBOL WA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  String msg = Uri.encodeFull(
                    "Halo, saya ingin memesan $nama dengan harga Rp ${formatHarga(harga)}",
                  );
                  openWhatsApp(msg);
                },
                icon: Icon(Icons.call, color: Colors.white),
                label: Text(
                  "Pesan via WhatsApp",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
