import 'package:flutter/material.dart';

class KelolaNotifikasiPage extends StatelessWidget {
  const KelolaNotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Notifikasi"),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Text(
          "Fitur Kelola Notifikasi\n(Coming Soon 🚀)",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
