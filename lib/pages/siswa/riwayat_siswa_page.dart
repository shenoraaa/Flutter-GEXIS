import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatSiswaPage extends StatefulWidget {
  final int idUser;

  const RiwayatSiswaPage({super.key, required this.idUser});

  @override
  State<RiwayatSiswaPage> createState() => _RiwayatSiswaPageState();
}

class _RiwayatSiswaPageState extends State<RiwayatSiswaPage> {
  List riwayatList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    try {
      final url = Uri.parse(
        "http://192.168.1.7/api_fluttergexis/get_riwayat_siswa.php?id_user=${widget.idUser}",
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          riwayatList = data['data'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "diterima":
        return Colors.green;
      case "ditolak":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pendaftaran"),
        backgroundColor: Colors.green,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : riwayatList.isEmpty
          ? const Center(child: Text("Belum pernah mendaftar ekskul"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayatList.length,
              itemBuilder: (context, index) {
                final data = riwayatList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      data['nama_ekskul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Kelas: ${data['kelas']}\n"
                      "Status: ${data['status']}",
                      style: TextStyle(color: getStatusColor(data['status'])),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
