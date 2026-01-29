import 'dart:convert';
import 'package:flutter/material.dart';
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

  final String baseUrl = "http://10.113.3.70/api_fluttergexis/";

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengambil data"),
          backgroundColor: Colors.red,
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
            backgroundColor: Colors.green,
          ),
        );
        getEkskul();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonData['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Koneksi ke server gagal"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// 🔥 FUNGSI AMAN UNTUK URL GAMBAR
  String getImageUrl(String gambar) {
    if (gambar.startsWith("http")) {
      return gambar;
    }

    if (gambar.startsWith("upload/")) {
      return baseUrl + gambar;
    }

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
      appBar: AppBar(
        title: const Text("Riwayat Ekstrakurikuler"),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ekskul.isEmpty
          ? const Center(child: Text("Belum ada data ekstrakurikuler"))
          : ListView.builder(
              itemCount: ekskul.length,
              itemBuilder: (context, i) {
                final e = ekskul[i];

                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        getImageUrl(e['gambar'] ?? ""),
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 55,
                            height: 55,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      e['nama_ekskul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(e['pembina']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditEkskulPage(data: e),
                              ),
                            ).then((_) => getEkskul());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Hapus Data"),
                                content: const Text(
                                  "Yakin ingin menghapus ekstrakurikuler ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Batal"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      hapusEkskul(e['id']);
                                    },
                                    child: const Text("Hapus"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
