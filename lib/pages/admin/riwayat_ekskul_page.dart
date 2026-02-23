import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'edit_ekskul_page.dart';

class RiwayatEkskulPage extends StatefulWidget {
  const RiwayatEkskulPage({super.key});

  @override
  State<RiwayatEkskulPage> createState() => _RiwayatEkskulPageState();
}

class _RiwayatEkskulPageState extends State<RiwayatEkskulPage> {
  List ekskul = [];
  bool isLoading = true;

  final String baseUrl = "http://192.168.1.7/api_fluttergexis/";

  Future<void> getEkskul() async {
    try {
      final res = await http.get(Uri.parse("${baseUrl}dapat_ekskul.php"));
      final data = json.decode(res.body);

      setState(() {
        ekskul = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> hapusEkskul(String id) async {
    try {
      final res = await http.post(
        Uri.parse("${baseUrl}hapus_ekskul.php"),
        body: {'id': id},
      );

      final jsonData = json.decode(res.body);

      if (jsonData['success'] == true) {
        getEkskul();
      }
    } catch (e) {}
  }

  String getImageUrl(String gambar) {
    if (gambar.startsWith("http")) return gambar;
    if (gambar.startsWith("upload/")) return baseUrl + gambar;
    return baseUrl + "upload/" + gambar;
  }

  @override
  void initState() {
    super.initState();
    getEkskul();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),

      appBar: AppBar(
        title: Text(
          "Riwayat Ekstrakurikuler",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ekskul.isEmpty
          ? Center(
              child: Text(
                "Belum ada data ekstrakurikuler",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(25),
              itemCount: ekskul.length,
              itemBuilder: (context, i) {
                final e = ekskul[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Row(
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            getImageUrl(e['gambar'] ?? ""),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 20),

                        /// TEXT INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['nama_ekskul'],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Pembina: ${e['pembina']}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ACTION BUTTONS
                        Row(
                          children: [
                            _iconButton(
                              icon: Icons.edit,
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditEkskulPage(data: e),
                                  ),
                                ).then((_) => getEkskul());
                              },
                            ),

                            const SizedBox(width: 10),

                            _iconButton(
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Text(
                                      "Hapus Data",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      "Yakin ingin menghapus data ini?",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(
                                          "Batal",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          hapusEkskul(e['id']);
                                        },
                                        child: Text(
                                          "Hapus",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// Custom Rounded Icon Button
  Widget _iconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Icon(icon, color: color),
      ),
    );
  }
}
