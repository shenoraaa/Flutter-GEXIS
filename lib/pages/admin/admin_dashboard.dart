import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tambah_ekskul_page.dart';
import 'kelola_user.dart';
import 'riwayat_ekskul_page.dart';
import 'kelola_notifikasi_page.dart';
import 'riwayat_pendaftaran_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  bool isCollapsed = false;

  final Color primary = const Color(0xFF1976D2);

  final Color sidebarDark = const Color(0xFF0F2027);
  final Color sidebarMid = const Color(0xFF203A43);

  final Color contentBg = const Color(0xFFF1F5F9);
  final Color cardBg = Colors.white;

  final double expandedWidth = 260;
  final double collapsedWidth = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: contentBg,
      body: Row(
        children: [
          /// ================= SIDEBAR =================
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? collapsedWidth : expandedWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [sidebarDark, sidebarMid],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                /// TOGGLE BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      isCollapsed ? Icons.menu : Icons.menu_open,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// LOGO
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCollapsed ? 0 : 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.school, color: Colors.white),
                      ),

                      if (!isCollapsed) ...[
                        const SizedBox(width: 12),
                        Text(
                          "G-EXIS",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                sidebarItem(Icons.dashboard, "Dashboard", 0),
                sidebarItem(Icons.add, "Tambah Ekskul", 1),
                sidebarItem(Icons.history, "Riwayat Ekskul", 2),
                sidebarItem(Icons.assignment, "Riwayat Daftar", 3),
                sidebarItem(Icons.people, "Kelola User", 4),
                sidebarItem(Icons.notifications, "Notifikasi", 5),
              ],
            ),
          ),

          /// ================= CONTENT =================
          Expanded(
            child: Column(
              children: [
                /// HEADER
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: cardBg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dashboard",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const CircleAvatar(
                        backgroundColor: Color(0xFF1976D2),
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                /// PAGE CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: selectedIndex == 0 ? dashboardHome() : pageRouter(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SIDEBAR ITEM =================
  Widget sidebarItem(IconData icon, String title, int index) {
    bool selected = selectedIndex == index;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCollapsed ? 12 : 10,
        vertical: 6,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: selected ? primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isCollapsed
              /// COLLAPSED MODE (ICON CENTER PERFECT)
              ? Center(
                  child: Icon(
                    icon,
                    color: selected ? Colors.white : Colors.white70,
                  ),
                )
              /// EXPANDED MODE
              : Row(
                  children: [
                    const SizedBox(width: 12),

                    Icon(icon, color: selected ? Colors.white : Colors.white70),

                    const SizedBox(width: 14),

                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// ================= DASHBOARD HOME =================
  Widget dashboardHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Statistik",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            statCard("Total Ekskul", "12", Icons.school),
            const SizedBox(width: 20),
            statCard("Total Siswa", "245", Icons.people),
            const SizedBox(width: 20),
            statCard("Total Pembina", "8", Icons.person),
            const SizedBox(width: 20),
            statCard("Pendaftaran", "54", Icons.assignment),
          ],
        ),
      ],
    );
  }

  /// ================= STAT CARD =================
  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primary),

            const Spacer(),

            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(title),
          ],
        ),
      ),
    );
  }

  /// ================= PAGE ROUTER =================
  Widget pageRouter() {
    switch (selectedIndex) {
      case 1:
        return const TambahEkskulPage();

      case 2:
        return const RiwayatEkskulPage();

      case 3:
        return const RiwayatPendaftaranPage();

      case 4:
        return const KelolaUserPage();

      case 5:
        return const KelolaNotifikasiPage();

      default:
        return dashboardHome();
    }
  }
}
