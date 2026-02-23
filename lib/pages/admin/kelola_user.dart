import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../models/user_model.dart';

class KelolaUserPage extends StatefulWidget {
  const KelolaUserPage({super.key});

  @override
  State<KelolaUserPage> createState() => _KelolaUserPageState();
}

class _KelolaUserPageState extends State<KelolaUserPage> {
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  bool isLoading = true;

  final String baseUrl = "http://192.168.1.7/api_fluttergexis/";

  final TextEditingController searchC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  String selectedRole = 'siswa';

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}get_users.php"));

      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          allUsers = (data['data'] as List)
              .map((e) => UserModel.fromJson(e))
              .toList();
          filteredUsers = allUsers;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void searchUser(String keyword) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final key = keyword.toLowerCase();
        return user.nama.toLowerCase().contains(key) ||
            user.username.toLowerCase().contains(key) ||
            user.role.toLowerCase().contains(key);
      }).toList();
    });
  }

  Future<void> tambahUser() async {
    final response = await http.post(
      Uri.parse("${baseUrl}tambah_user.php"),
      body: {
        'nama': namaC.text,
        'username': usernameC.text,
        'password': passwordC.text,
        'role': selectedRole,
      },
    );

    final data = json.decode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data['message']),
        backgroundColor: data['success'] ? Colors.green : Colors.red,
      ),
    );

    if (data['success'] == true) {
      Navigator.pop(context);
      namaC.clear();
      usernameC.clear();
      passwordC.clear();
      getUsers();
    }
  }

  void showTambahUserDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tambah User",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              _inputField(namaC, "Nama"),
              const SizedBox(height: 12),
              _inputField(usernameC, "Username"),
              const SizedBox(height: 12),
              _inputField(passwordC, "Password", obscure: true),
              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'siswa', child: Text("Siswa")),
                  DropdownMenuItem(value: 'pembina', child: Text("Pembina")),
                  DropdownMenuItem(value: 'admin', child: Text("Admin")),
                ],
                onChanged: (value) {
                  setState(() => selectedRole = value!);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal", style: GoogleFonts.poppins()),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: tambahUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0f172a),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Simpan", style: GoogleFonts.poppins()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Color roleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xffef4444);
      case 'pembina':
        return const Color(0xfff59e0b);
      default:
        return const Color(0xff16a34a);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),

      appBar: AppBar(
        title: Text(
          "Kelola User",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff0f172a),
        child: const Icon(Icons.add),
        onPressed: showTambahUserDialog,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// SEARCH
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: searchC,
                    onChanged: searchUser,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: "Cari user...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// LIST
                Expanded(
                  child: filteredUsers.isEmpty
                      ? Center(
                          child: Text(
                            "User tidak ditemukan",
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  /// ICON
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: roleColor(
                                      user.role,
                                    ).withOpacity(0.15),
                                    child: Icon(
                                      Icons.person,
                                      color: roleColor(user.role),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  /// TEXT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.nama,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user.username,
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ROLE BADGE
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: roleColor(
                                        user.role,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: roleColor(user.role),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
