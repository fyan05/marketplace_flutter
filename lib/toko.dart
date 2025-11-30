import 'package:final_project/api-service.dart';
import 'package:final_project/edit-toko.dart';
import 'package:final_project/edit.dart';
import 'package:final_project/tambah-produk.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  final api = ApiServices();
  bool loading = true;
  bool loadingProducts = true;

  Map<String, dynamic>? store;
  List products = [];
  // --- NORMALISASI PRODUK ---
  Map<String, dynamic> normalizeProduct(Map<String, dynamic> p) {
    return {
      "id_produk": p["id_produk"] ?? p["id"] ?? 0,
      "nama_produk": p["nama_produk"] ?? p["nama"] ?? "",
      "harga": p["harga"] ?? 0,
      "stok": p["stok"] ?? 0,
      "deskripsi": p["deskripsi"] ?? "",
      "id_kategori": p["id_kategori"] ?? p["kategori_id"] ?? 0,
      "gambar": p["gambar"] ?? p["image"] ?? "",
    };
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await fetchMyStore();
    await fetchProducts();
  }

  Future<void> fetchMyStore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final data = await api.getMyStore(token);

      setState(() {
        store = data;
        loading = false;
      });
    } catch (e) {
      print("Gagal load toko: $e");
      setState(() => loading = false);
    }
  }

  Future<void> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;

      final data = await api.getMyStoreProducts(token);

      setState(() {
        products = data;
        loadingProducts = false;
      });
    } catch (e) {
      print("Gagal load produk toko: $e");
      setState(() => loadingProducts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Toko Saya"),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : store == null
              ? const Center(
                  child: Text(
                  "Anda belum memiliki toko.",
                  style: TextStyle(fontSize: 18),
                ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ------------------- DETAIL TOKO ---------------------
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 6,
                        shadowColor: Colors.blue.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.network(
                                store!["gambar"] ??
                                    "https://learncode.biz.id/images/no-image.png",
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store!["nama_toko"] ?? "-",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    store!["deskripsi"] ?? "-",
                                    style: const TextStyle(fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone,
                                          size: 18, color: Colors.green),
                                      const SizedBox(width: 6),
                                      Text(store!["kontak_toko"] ?? "-"),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 18, color: Colors.red),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          store!["alamat"] ?? "-",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // ===================== TOMBOL EDIT TOKO ======================
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.orange.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  EditStorePage(store: store!),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text("Edit Toko"),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const AddProductPage(),
                                            ),
                                          );
                                          if (result == true) {
                                            fetchProducts();
                                          }
                                        },
                                        icon:
                                            const Icon(Icons.add_box_outlined),
                                        label: const Text("Tambah Produk"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ------------------- PRODUK TOKO ---------------------
                      Text(
                        "Produk Saya",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),

                      loadingProducts
                          ? const Center(child: CircularProgressIndicator())
                          : products.isEmpty
                              ? const Center(child: Text("Belum ada produk."))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final p = products[index];
                                    final fixed = normalizeProduct(p);

                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        leading: Image.network(
                                          p["gambar"] ??
                                              "https://learncode.biz.id/images/no-image.png",
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(p["nama_produk"] ?? "-"),
                                        subtitle: Text(
                                            "Harga: Rp ${p["harga"] ?? '-'} • Stok: ${p["stok"] ?? '-'}"),

                                        // ================= TRAILING (EDIT + DELETE) =================
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // --- TOMBOL EDIT YANG SUDAH FIX ---
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        EditProductPage(
                                                            product: fixed),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                final confirm =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                    title: const Text(
                                                        "Hapus Produk"),
                                                    content: Text(
                                                        "Yakin ingin menghapus '${p["nama_produk"]}'?"),
                                                    actions: [
                                                      TextButton(
                                                        child:
                                                            const Text("Batal"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                        child:
                                                            const Text("Hapus"),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm == true) {
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  final token =
                                                      prefs.getString('token');

                                                  if (token == null) return;

                                                  final success =
                                                      await api.deleteProduct(
                                                          p["id_produk"],
                                                          token);

                                                  if (success) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Produk berhasil dihapus"),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                    fetchProducts();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Gagal menghapus produk"),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
    );
  }
}
