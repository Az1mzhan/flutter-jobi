import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._preferences);

  final SharedPreferences _preferences;

  static Future<PreferencesService> create() async {
    final preferences = await SharedPreferences.getInstance();
    return PreferencesService(preferences);
  }

  String? getString(String key) => _preferences.getString(key);

  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  List<String>? getStringList(String key) => _preferences.getStringList(key);

  Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }
}
