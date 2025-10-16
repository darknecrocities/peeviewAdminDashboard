// lib/supabase_options.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOptions {
  // Your Supabase credentials
  static const String supabaseUrl = 'https://qhfovmwerbgrupdidral.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFoZm92bXdlcmJncnVwZGlkcmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0MDkyODIsImV4cCI6MjA2OTk4NTI4Mn0.8jiX-K_z9XC7CvKZyfymE4EbUTnogyk6xVIDIgOZPOk';

  // Initialize Supabase (call this in main before runApp)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // optional: shows logs in console
    );
  }

  // Access the Supabase client anywhere
  static SupabaseClient get client => Supabase.instance.client;
}
