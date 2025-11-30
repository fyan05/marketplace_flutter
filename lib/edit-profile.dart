import 'package:final_project/api-service.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String token;

  const EditProfilePage({super.key, required this.token});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final api = ApiServices();
      final data = await api.getUserProfile(widget.token);

      setState(() {
        nameController.text = data["nama"] ?? "";
        emailController.text = data["username"] ?? "";
        phoneController.text = data["kontak"] ?? "";
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  Future<void> saveProfile() async {
    setState(() => saving = true);

    try {
      final api = ApiServices();
      await api.updateUserProfile(
        widget.token,
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
      );

      setState(() => saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        title: const Text(
          "Edit Profil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Nomor HP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: saving ? null : saveProfile,
                      child: saving
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Simpan Perubahan",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
