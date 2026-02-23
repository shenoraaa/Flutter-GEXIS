import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TambahEkskulPage extends StatefulWidget {
  const TambahEkskulPage({super.key});

  @override
  State<TambahEkskulPage> createState() => _TambahEkskulPageState();
}

class _TambahEkskulPageState extends State<TambahEkskulPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController pembinaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  Uint8List? selectedImageBytes;
  XFile? pickedImage;

  bool isLoading = false;

  /* ================= PILIH GAMBAR ================= */
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        pickedImage = image;
        selectedImageBytes = bytes;
      });
    }
  }

  /* ================= SIMPAN ================= */
  Future<void> simpan() async {
    if (namaController.text.isEmpty ||
        pembinaController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field & gambar wajib diisi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uri = Uri.parse(
        'http://192.168.1.7/api_fluttergexis/tambah_ekskul.php',
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll({
        'nama_ekskul': namaController.text.trim(),
        'pembina': pembinaController.text.trim(),
        'deskripsi': deskripsiController.text.trim(),
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'gambar',
          selectedImageBytes!,
          filename: pickedImage!.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final data = json.decode(body);

      if (!mounted) return;

      if (data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ekskul berhasil ditambahkan"),
            backgroundColor: Colors.green,
          ),
        );

        // reset form biar aman
        namaController.clear();
        pembinaController.clear();
        deskripsiController.clear();

        setState(() {
          selectedImageBytes = null;
          pickedImage = null;
        });

        // Delay sebelum kembali (anti putih)
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Gagal menambahkan"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ERROR: $e"), backgroundColor: Colors.red),
      );
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),
      appBar: AppBar(
        title: Text(
          "Tambah Ekstrakurikuler",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 60,
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: const Color(0xfff8fafc),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: selectedImageBytes == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Upload Gambar",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.memory(
                                      selectedImageBytes!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),

                      /// FORM
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Informasi Ekstrakurikuler",
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 25),
                            _buildTextField(
                              controller: namaController,
                              hint: "Nama Ekstrakurikuler",
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: pembinaController,
                              hint: "Nama Pembina",
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: deskripsiController,
                              hint: "Deskripsi",
                              maxLines: 5,
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : simpan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0f172a),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        "Simpan",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xfff8fafc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
