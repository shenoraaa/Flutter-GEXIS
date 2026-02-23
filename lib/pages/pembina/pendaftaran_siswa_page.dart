import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PendaftaranSiswaPage extends StatefulWidget {
  final int idEkskul;

  const PendaftaranSiswaPage({super.key, required this.idEkskul});

  @override
  State<PendaftaranSiswaPage> createState() => _PendaftaranSiswaPageState();
}

class _PendaftaranSiswaPageState extends State<PendaftaranSiswaPage> {
  List pendaftar = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPendaftaran();
  }

  Future<void> fetchPendaftaran() async {
    final url = Uri.parse(
      "http://192.168.1.7/api_fluttergexis/get_pendaftaran_by_ekskul.php?id_ekskul=${widget.idEkskul}",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data['success'] == true) {
      setState(() {
        pendaftar = data['data'];
        loading = false;
      });
    }
  }

  Future<void> updateStatus(String id, String status) async {
    final url = Uri.parse(
      "http://192.168.1.7/api_fluttergexis/update_status.php",
    );

    await http.post(url, body: {"id": id, "status": status});

    fetchPendaftaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pendaftaran Siswa"),
        backgroundColor: Colors.purple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pendaftar.isEmpty
          ? const Center(child: Text("Belum ada pendaftaran"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendaftar.length,
              itemBuilder: (context, index) {
                final data = pendaftar[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(data['nama_siswa']),
                    subtitle: Text(
                      "Kelas: ${data['kelas']}\nStatus: ${data['status']}",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateStatus(data['id'], "diterima"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateStatus(data['id'], "ditolak"),
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
