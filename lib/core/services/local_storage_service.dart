import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> set(String key, String value) async {
    final prefs = await _getPreferences();
    await prefs.setString(key, value);
  }

  Future<String?> get(String key) async {
    final prefs = await _getPreferences();
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await _getPreferences();
    await prefs.remove(key);
  }

  Future<void> clear() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }
}
