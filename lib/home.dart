import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
  final String token;
  final int userId;
  const homepage({super.key, required this.token, required this.userId});
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================== HEADER ==================
              Container(
                color: Colors.green[600],
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_offer, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Promo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.home, color: Colors.white),
                            const SizedBox(width: 20),
                            const Icon(Icons.chat, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Search bar
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            "Placeholder text",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Saldo card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "gopay",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Rp0.000.000",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _iconText(Icons.add, "Top Up"),
                              _iconText(Icons.call_made, "Pay"),
                              _iconText(Icons.history, "Explore"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ================== MAIN CONTENT ==================
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Top picks for you",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _tabCategory("All", true),
                        _tabCategory("Promo", false),
                        _tabCategory("News", false),
                        _tabCategory("Entertainment", false),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Try this resto?",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Find most curated resto selected by you",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _foodCard(
                            "assets/food1.jpg",
                            "Starbucks",
                            "⭐ 4.8 | Coffee & Tea",
                          ),
                          _foodCard(
                            "assets/food2.jpg",
                            "Bakmi GM",
                            "⭐ 4.6 | Noodles",
                          ),
                          _foodCard(
                            "assets/food3.jpg",
                            "Kopi Kenangan",
                            "⭐ 4.7 | Coffee",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ================== BOTTOM NAVIGATION ==================
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(0), // lancip
                    bottomRight: Radius.circular(0), // lancip
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _bottomNavItem(Icons.local_offer, "Promo", true),
                    _bottomNavItem(Icons.home, "Home", false),
                    _bottomNavItem(Icons.chat, "Chat", false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== Widget Helper ==================
Widget _iconText(IconData icon, String text) {
  return Column(
    children: [
      Icon(icon, color: Colors.white),
      const SizedBox(height: 4),
      Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ],
  );
}

Widget _tabCategory(String title, bool active) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: active ? Colors.green[600] : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green),
    ),
    child: Text(
      title,
      style: TextStyle(
        color: active ? Colors.white : Colors.green[700],
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _foodCard(String imgPath, String name, String desc) {
  return Container(
    width: 140,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.asset(
            imgPath,
            width: 140,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _bottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _bottomNavItem(this.icon, this.label, this.active, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? Colors.green[600] : Colors.grey),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.green[600] : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
