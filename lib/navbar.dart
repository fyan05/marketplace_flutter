import 'package:final_project/home.dart';
import 'package:final_project/produk.dart';
import 'package:final_project/profile.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final String token;
  final int userId;
  final String nama;

  const MainNavigation({
    super.key,
    required this.token,
    required this.userId,
    required this.nama,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePage(userId: widget.userId, token: widget.token, nama: widget.nama),
      ProductPage(token: widget.token),
      ProfilePage(nama: widget.nama),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() => index = value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: "Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
