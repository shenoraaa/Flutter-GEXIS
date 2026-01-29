import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditEkskulPage extends StatefulWidget {
  final Map data;

  const EditEkskulPage({super.key, required this.data});

  @override
  State<EditEkskulPage> createState() => _EditEkskulPageState();
}

class _EditEkskulPageState extends State<EditEkskulPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pembinaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  File? imageFile;
  bool isLoading = false;

  final String baseUrl = "http://10.113.3.70/api_fluttergexis/";

  @override
  void initState() {
    super.initState();

    // isi data awal
    namaController.text = widget.data['nama_ekskul'];
    pembinaController.text = widget.data['pembina'];
    deskripsiController.text = widget.data['deskripsi'] ?? '';
  }

  /// 📸 pilih gambar
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  /// 🔥 UPDATE DATA
  Future<void> updateEkskul() async {
    setState(() => isLoading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${baseUrl}edit_ekskul.php"),
      );

      request.fields['id'] = widget.data['id'];
      request.fields['nama_ekskul'] = namaController.text;
      request.fields['pembina'] = pembinaController.text;
      request.fields['deskripsi'] = deskripsiController.text;

      // ⚠️ kirim gambar HANYA jika dipilih
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', imageFile!.path),
        );
      }

      final res = await request.send();
      final body = await res.stream.bytesToString();
      final jsonData = json.decode(body);

      setState(() => isLoading = false);

      if (jsonData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal terhubung ke server"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 🔗 handle URL gambar
  String getImageUrl(String gambar) {
    if (gambar.startsWith("http")) return gambar;
    return baseUrl + "upload/" + gambar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Ekstrakurikuler"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🖼️ PREVIEW GAMBAR
            GestureDetector(
              onTap: pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageFile != null
                    ? Image.file(
                        imageFile!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        getImageUrl(widget.data['gambar']),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 180,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 10),
            const Text("Tap gambar untuk mengganti"),

            const SizedBox(height: 20),

            /// ✏️ NAMA
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Ekstrakurikuler",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// 👤 PEMBINA
            TextField(
              controller: pembinaController,
              decoration: const InputDecoration(
                labelText: "Pembina",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// 📝 DESKRIPSI
            TextField(
              controller: deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            /// 🔘 BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: isLoading ? null : updateEkskul,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SIMPAN PERUBAHAN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
