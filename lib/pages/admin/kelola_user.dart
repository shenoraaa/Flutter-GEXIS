import 'dart:convert';
import 'package:flutter/material.dart';
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

  final String baseUrl = "http://10.113.3.70/api_fluttergexis/";

  final TextEditingController searchC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  String selectedRole = 'siswa';

  // ================= GET USERS =================
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

  // ================= SEARCH =================
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

  // ================= TAMBAH USER =================
  Future<void> tambahUser() async {
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal koneksi ke server"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= DIALOG TAMBAH USER =================
  void showTambahUserDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah User"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaC,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: usernameC,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: passwordC,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 10),
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
                decoration: const InputDecoration(labelText: "Role"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(onPressed: tambahUser, child: const Text("Simpan")),
        ],
      ),
    );
  }

  Color roleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'pembina':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola User"),
        backgroundColor: Colors.blue,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: showTambahUserDialog,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchC,
                    onChanged: searchUser,
                    decoration: InputDecoration(
                      hintText: "Cari nama / username / role",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // LIST USER
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(child: Text("User tidak ditemukan"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const Icon(Icons.person),
                                title: Text(
                                  user.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Username: ${user.username}"),
                                    Text(
                                      "Role: ${user.role}",
                                      style: TextStyle(
                                        color: roleColor(user.role),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
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
