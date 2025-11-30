import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final namaC = TextEditingController();
  final kontakC = TextEditingController();
  final usernameC = TextEditingController();
  final passC = TextEditingController();

  bool loading = false;

  Future<void> registerUser() async {
    setState(() => loading = true);

    final url = Uri.parse("https://learncode.biz.id/api/register");

    final res = await http.post(
      url,
      body: {
        "nama": namaC.text,
        "kontak": kontakC.text,
        "username": usernameC.text,
        "password": passC.text,
      },
    );

    setState(() => loading = false);

    final data = json.decode(res.body);

    if (res.statusCode == 201 && data["success"] == true) {
      // Registrasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi berhasil")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Registrasi gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Color.fromARGB(255, 73, 243, 118),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaC,
              decoration: const InputDecoration(labelText: "Nama lengkap"),
            ),
            TextField(
              controller: kontakC,
              decoration: const InputDecoration(labelText: "Kontak (HP)"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: usernameC,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passC,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 73, 243, 118),
                    ),
                    onPressed: registerUser,
                    child: const Text("Daftar"),
                  )
          ],
        ),
      ),
    );
  }
}
