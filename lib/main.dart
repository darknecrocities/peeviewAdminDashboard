import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // <-- import your generated options

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <-- init with options
  );
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
