import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RiwayatPendaftaranPage extends StatefulWidget {
  const RiwayatPendaftaranPage({super.key});

  @override
  State<RiwayatPendaftaranPage> createState() => _RiwayatPendaftaranPageState();
}

class _RiwayatPendaftaranPageState extends State<RiwayatPendaftaranPage> {
  List pendaftaranList = [];
  bool loading = true;

  final String baseUrl = "http://192.168.1.7/api_fluttergexis/";

  @override
  void initState() {
    super.initState();
    fetchPendaftaran();
  }

  Future<void> fetchPendaftaran() async {
    try {
      final response = await http.get(
        Uri.parse("${baseUrl}get_all_pendaftaran.php"),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          pendaftaranList = data['data'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> updateStatus(String id, String status) async {
    await http.post(
      Uri.parse("${baseUrl}update_status.php"),
      body: {"id": id, "status": status},
    );

    fetchPendaftaran();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "diterima":
        return const Color(0xff16a34a);
      case "ditolak":
        return const Color(0xffdc2626);
      default:
        return const Color(0xfff59e0b);
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "diterima":
        return Icons.check_circle_rounded;
      case "ditolak":
        return Icons.cancel_rounded;
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),

      appBar: AppBar(
        title: Text(
          "Riwayat Pendaftaran",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pendaftaranList.isEmpty
          ? Center(
              child: Text(
                "Belum ada pendaftaran",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(25),
              itemCount: pendaftaranList.length,
              itemBuilder: (context, index) {
                final data = pendaftaranList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xff0f172a).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Color(0xff0f172a),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Text(
                              data['nama_siswa'],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          /// STATUS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                data['status'],
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  getStatusIcon(data['status']),
                                  size: 16,
                                  color: getStatusColor(data['status']),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  data['status'].toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: getStatusColor(data['status']),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      /// DETAIL INFO
                      Row(
                        children: [
                          const Icon(
                            Icons.school_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data['nama_ekskul'],
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.class_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Kelas ${data['kelas']}",
                            style: GoogleFonts.poppins(),
                          ),
                        ],
                      ),

                      /// ACTION BUTTONS
                      if (data['status'] == "pending") ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    updateStatus(data['id'], "diterima"),
                                icon: const Icon(Icons.check, size: 18),
                                label: Text(
                                  "Terima",
                                  style: GoogleFonts.poppins(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff16a34a),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    updateStatus(data['id'], "ditolak"),
                                icon: const Icon(Icons.close, size: 18),
                                label: Text(
                                  "Tolak",
                                  style: GoogleFonts.poppins(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffdc2626),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
