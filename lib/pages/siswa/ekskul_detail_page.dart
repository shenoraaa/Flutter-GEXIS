import 'package:flutter/material.dart';
import 'form_pendaftaran_ekskul_page.dart';

class EkskulDetailPage extends StatelessWidget {
  final Map ekskul;

  const EkskulDetailPage({super.key, required this.ekskul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ekskul['nama_ekskul'] ?? 'Detail Ekskul'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama ekskul
            Text(
              ekskul['nama_ekskul'] ?? '-',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Pembina
            Text(
              'Pembina: ${ekskul['pembina'] ?? '-'}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ekskul['deskripsi'] ?? '-',
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            // Tombol daftar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormPendaftaranEkskulPage(
                        namaSiswa: 'lars', // sementara (nanti dari login)
                        namaEkskul: ekskul['nama_ekskul'] ?? '',
                        // 🔥 FIX ERROR STRING → INT
                        idEkskul: int.parse(ekskul['id'].toString()),
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Daftar Ekskul',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
