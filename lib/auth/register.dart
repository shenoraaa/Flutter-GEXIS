import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final namaC = TextEditingController();
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();

  bool loading = false;
  bool hidePassword = true;

  final Color primaryBlue = const Color(0xFF1976D2);

  Future<void> register() async {
    if (namaC.text.isEmpty ||
        usernameC.text.isEmpty ||
        passwordC.text.isEmpty) {
      showMessage("Semua field wajib diisi");
      return;
    }

    setState(() => loading = true);

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7/api_fluttergexis/register.php'),
        body: {
          'nama': namaC.text.trim(),
          'username': usernameC.text.trim(),
          'password': passwordC.text,
        },
      );

      setState(() => loading = false);

      final data = json.decode(response.body);

      if (data['success'] == true) {
        showMessage("Register berhasil", success: true);

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      } else {
        showMessage(data['message'] ?? "Register gagal");
      }
    } catch (e) {
      setState(() => loading = false);
      showMessage("Error: $e");
    }
  }

  void showMessage(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// BUBBLE LEFT
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// BUBBLE RIGHT
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// CARD
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 42,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// ICON
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// TITLE
                      Text(
                        "REGISTER",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Buat akun siswa G-EXIS",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// NAMA
                      TextField(
                        controller: namaC,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          hintStyle: GoogleFonts.poppins(color: Colors.white60),
                          prefixIcon: Icon(Icons.badge, color: primaryBlue),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// USERNAME
                      TextField(
                        controller: usernameC,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: GoogleFonts.poppins(color: Colors.white60),
                          prefixIcon: Icon(Icons.person, color: primaryBlue),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// PASSWORD
                      TextField(
                        controller: passwordC,
                        obscureText: hidePassword,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: GoogleFonts.poppins(color: Colors.white60),
                          prefixIcon: Icon(Icons.lock, color: primaryBlue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: primaryBlue,
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// BUTTON REGISTER
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading ? null : register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "REGISTER",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sudah punya akun? Login",
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
