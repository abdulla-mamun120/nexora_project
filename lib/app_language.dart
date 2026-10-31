import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Keeps the selected language for the whole app
class AppLanguage {
  // 'English' or 'Bangla'
  static final ValueNotifier<String> current =
      ValueNotifier<String>('English');

  static bool get isBangla => current.value == 'Bangla';

  // Reads the saved language when the app starts
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    current.value = prefs.getString('language') ?? 'English';
  }

  // Changes the language and saves it
  static Future<void> set(String language) async {
    current.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}