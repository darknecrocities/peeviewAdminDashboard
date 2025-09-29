import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DashboardApp());
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return MaterialApp(
      title: 'Clinic Dashboard',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.interTextTheme(base.textTheme),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardScreen(),
    );
  }
}
