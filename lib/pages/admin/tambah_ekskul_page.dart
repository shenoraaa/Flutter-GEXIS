import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TambahEkskulPage extends StatefulWidget {
  const TambahEkskulPage({super.key});

  @override
  State<TambahEkskulPage> createState() => _TambahEkskulPageState();
}

class _TambahEkskulPageState extends State<TambahEkskulPage> {
  final namaEkskulC = TextEditingController();
  final pembinaC = TextEditingController();
  final deskripsiC = TextEditingController();

  final ImagePicker picker = ImagePicker();
  Uint8List? imageBytes;
  XFile? pickedImage;

  /* ================= PILIH GAMBAR ================= */
  Future<void> pilihGambar() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        pickedImage = img;
        imageBytes = bytes;
      });
    }
  }

  /* ================= SIMPAN ================= */
  Future<void> simpanEkskul() async {
    if (namaEkskulC.text.isEmpty ||
        pembinaC.text.isEmpty ||
        deskripsiC.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    try {
      final uri = Uri.parse(
        'http://10.113.3.133/api_fluttergexis/tambah_ekskul.php',
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'nama_ekskul': namaEkskulC.text.trim(),
        'pembina': pembinaC.text.trim(),
        'deskripsi': deskripsiC.text.trim(),
      });

      // ✅ WAJIB: KIRIM GAMBAR
      if (pickedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar',
            pickedImage!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      debugPrint('STATUS: ${streamedResponse.statusCode}');
      debugPrint('BODY: $responseBody');

      final data = json.decode(responseBody);

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ekskul berhasil ditambahkan')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ERROR: $e')));
      debugPrint('ERROR DETAIL: $e');
    }
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ekstrakurikuler'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          GestureDetector(
            onTap: pilihGambar,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey),
                color: Colors.grey.shade200,
              ),
              child: imageBytes == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40),
                          SizedBox(height: 8),
                          Text('Pilih Gambar Ekskul'),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: namaEkskulC,
            decoration: const InputDecoration(
              labelText: 'Nama Ekstrakurikuler',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: pembinaC,
            decoration: const InputDecoration(
              labelText: 'Nama Pembina',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: deskripsiC,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: simpanEkskul,
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}
