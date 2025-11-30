import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kategori.dart';

class HomePage extends StatefulWidget {
  final String token;
  final int userId;
  final String nama;

  const HomePage({
    super.key,
    required this.token,
    required this.userId,
    required this.nama,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final res = await http.get(
        Uri.parse("https://learncode.biz.id/api/products"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      final data = jsonDecode(res.body);

      setState(() {
        products = data["data"];
        loading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          margin: const EdgeInsets.only(top: 18, left: 16, right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // PROFILE
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      "https://i.pinimg.com/474x/eb/5d/09/eb5d09f051d690516566ae835d90a30a.jpg",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Selamat Datang",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        widget.nama,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ICON NOTIF
              Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),

      //body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // herobanner
            Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=1200&q=80",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.all(18),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Beli Kebutuhanmu,\nPilih Sesukamu",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            //button kategori
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(token: widget.token),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Lihat Kategori",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Produk Terbaru",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            //list produk horizontal
            loading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Text("Tidak ada produk ditemukan")
                    : SizedBox(
                        height: 260,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final p = products[index];

                            String imageUrl = p["images"].isNotEmpty
                                ? "https://learncode.biz.id/${p["images"][0]["image"]}"
                                : "https://learncode.biz.id/images/no-image.png";

                            return Container(
                              width: 170,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 12,
                                    color: Colors.black.withOpacity(0.08),
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // IMAGE
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18)),
                                    child: Image.network(
                                      imageUrl,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // TEXT
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p["nama_produk"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Rp ${p["harga"]}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
