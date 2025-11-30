import 'dart:convert';
import 'package:final_project/edit-profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String token;

  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final url = Uri.parse("https://learncode.biz.id/api/profile");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${widget.token}",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        profile = data["data"];
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  void logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
            onPressed: () {
              Navigator.pop(ctx);

              // Setelah logout kembali ke halaman login
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          color: Colors.green.shade600,
        )),
      );
    }

    final nama = profile?["nama"] ?? "-";
    final username = profile?["username"] ?? "-";
    final kontak = profile?["kontak"] ?? "-";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: const Text("Profil Saya", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // CARD PROFIL
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green.shade600,
                    child:
                        const Icon(Icons.person, size: 45, color: Colors.white),
                  ),
                  const SizedBox(width: 20),

                  // INFO PROFIL
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        kontak,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            // MENU
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // EDIT PROFIL
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.green.shade600),
                    title: const Text("Edit Profil"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            token: widget.token,
                          ),
                        ),
                      ).then((_) => fetchProfile()); // refresh setelah update
                    },
                  ),

                  const Divider(height: 0),

                  // LOGOUT
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
