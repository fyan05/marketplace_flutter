import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditStorePage extends StatefulWidget {
  final Map<String, dynamic> store;

  const EditStorePage({super.key, required this.store});

  @override
  State<EditStorePage> createState() => _EditStorePageState();
}

class _EditStorePageState extends State<EditStorePage> {
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kontakController = TextEditingController();
  final alamatController = TextEditingController();
  final gambarController = TextEditingController();

  File? selectedImage;
  final picker = ImagePicker();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    namaController.text = widget.store["nama_toko"] ?? "";
    deskripsiController.text = widget.store["deskripsi"] ?? "";
    kontakController.text = widget.store["kontak_toko"] ?? "";
    alamatController.text = widget.store["alamat"] ?? "";
    gambarController.text =
        widget.store["gambar"] ?? ""; // cuma untuk tampil nama file
  }

  // PICK IMAGE
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        gambarController.text = picked.name;
      });
    }
  }

  // SAVE EDIT
  Future<void> saveEdit() async {
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() => loading = false);
      return;
    }

    final url = Uri.parse("https://learncode.biz.id/api/stores/save");

    var request = http.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["id_toko"] = widget.store["id_toko"].toString();
    request.fields["nama_toko"] = namaController.text;
    request.fields["desk_ripsi"] =
        deskripsiController.text; // BACKEND MEMAKAI desk_ripsi
    request.fields["kontak_toko"] = kontakController.text;
    request.fields["alamat"] = alamatController.text;

    // GAMBAR WAJIB FILE
    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          "gambar",
          selectedImage!.path,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    print("STATUS: ${response.statusCode}");
    print("BODY: $body");

    final data = jsonDecode(body);

    setState(() => loading = false);

    // SUKSES
    if (data["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Toko berhasil diperbarui!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
      return;
    }

    // VALIDASI GAGAL
    if (data["errors"] != null) {
      String msg = "";

      data["errors"].forEach((key, value) {
        msg += "- ${value[0]}\n";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // fallback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data["message"] ?? "Terjadi kesalahan."),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Toko"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // NAMA TOKO
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Toko",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // DESKRIPSI
              TextField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // KONTAK
              TextField(
                controller: kontakController,
                decoration: const InputDecoration(
                  labelText: "Kontak",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // ALAMAT
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // GAMBAR (NAMA FILE)
              TextField(
                controller: gambarController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "File Gambar",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // BUTTON PILIH GAMBAR
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pilih Gambar"),
              ),

              // PREVIEW
              if (selectedImage != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 150,
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 30),

              // BUTTON SIMPAN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: loading ? null : saveEdit,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
