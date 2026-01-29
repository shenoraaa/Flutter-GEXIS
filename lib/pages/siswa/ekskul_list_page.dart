import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EkskulListPage extends StatefulWidget {
  const EkskulListPage({super.key});

  @override
  State<EkskulListPage> createState() => _EkskulListPageState();
}

class _EkskulListPageState extends State<EkskulListPage> {
  List ekskulList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchEkskul();
  }

  Future<void> fetchEkskul() async {
    final url = Uri.parse("http://10.113.3.70/api_fluttergexis/get_ekskul.php");

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          ekskulList = data['data'];
          loading = false;
        });
      }
    } catch (e) {
      debugPrint('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ekstrakurikuler'),
        backgroundColor: Colors.green,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ekskulList.length,
              itemBuilder: (context, index) {
                final ekskul = ekskulList[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.groups, color: Colors.green),
                    title: Text(
                      ekskul['nama_ekskul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Pembina: ${ekskul['pembina']}'),
                        const SizedBox(height: 4),
                        Text(
                          ekskul['deskripsi'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Klik ${ekskul['nama_ekskul']}'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
