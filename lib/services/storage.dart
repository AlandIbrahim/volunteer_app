import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Method to save a key-value pair
  Future<void> save(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Method to read a value by key
  Future<String?> read(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
