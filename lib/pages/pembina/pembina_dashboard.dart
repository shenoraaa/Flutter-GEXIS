import 'package:flutter/material.dart';

class PembinaDashboard extends StatelessWidget {
  const PembinaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pembina'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.school, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Selamat Datang, Pembina',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Kelola anggota ekstrakurikuler'),
          ],
        ),
      ),
    );
  }
}
