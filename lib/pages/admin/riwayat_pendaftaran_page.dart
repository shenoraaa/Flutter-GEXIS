import 'package:flutter/material.dart';

class RiwayatPendaftaranPage extends StatelessWidget {
  const RiwayatPendaftaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pendaftaran"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          "Riwayat pendaftaran ekstrakurikuler\n(Coming Soon 🚀)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
