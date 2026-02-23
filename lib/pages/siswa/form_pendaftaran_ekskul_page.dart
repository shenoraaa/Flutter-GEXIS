import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPendaftaranEkskulPage extends StatefulWidget {
  final String namaSiswa;
  final String namaEkskul;
  final int idEkskul;

  const FormPendaftaranEkskulPage({
    super.key,
    required this.namaSiswa,
    required this.namaEkskul,
    required this.idEkskul,
  });

  @override
  State<FormPendaftaranEkskulPage> createState() =>
      _FormPendaftaranEkskulPageState();
}

class _FormPendaftaranEkskulPageState extends State<FormPendaftaranEkskulPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController alasanController = TextEditingController();

  bool loading = false;

  Future<void> kirimPendaftaran() async {
    setState(() => loading = true);

    final url = Uri.parse(
      "http://192.168.1.7/api_fluttergexis/simpan_pendaftaran.php",
    );

    final response = await http.post(
      url,
      body: {
        "id_ekskul": widget.idEkskul.toString(),
        "nama_siswa": widget.namaSiswa,
        "kelas": kelasController.text,
        "alasan": alasanController.text,
      },
    );

    final data = json.decode(response.body);

    setState(() => loading = false);

    if (data['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pendaftaran berhasil dikirim")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengirim pendaftaran")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Pendaftaran"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.namaSiswa,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Nama Siswa",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.namaEkskul,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Nama Ekskul",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: kelasController,
                decoration: const InputDecoration(
                  labelText: "Kelas",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Kelas wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: alasanController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Alasan",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Alasan wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          kirimPendaftaran();
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Pendaftaran"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
