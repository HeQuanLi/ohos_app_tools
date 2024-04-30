import 'package:shared_preferences/shared_preferences.dart';

///工具类
class SharedPreferencesUtil {
  static SharedPreferences? _prefs;

  // 私有构造函数，确保单例
  SharedPreferencesUtil._();

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> saveString(String key, String value) async {
    try {
      await _initPrefs();
      return await _prefs!.setString(key, value);
    } catch (e) {
      return false;
    }
  }

  static Future<String?> getString(String key, {String? defaultValue}) async {
    try {
      await _initPrefs();
      return _prefs!.getString(key);
    } catch (e) {
      return defaultValue;
    }
  }

  static Future<bool> saveInt(String key, int value) async {
    try {
      await _initPrefs();
      return await _prefs!.setInt(key, value);
    } catch (e) {
      return false;
    }
  }

  static Future<int?> getInt(String key) async {
    try {
      await _initPrefs();
      return _prefs!.getInt(key);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveBool(String key, bool value) async {
    try {
      await _initPrefs();
      return await _prefs!.setBool(key, value);
    } catch (e) {
      return false;
    }
  }

  static Future<bool?> getBool(String key) async {
    try {
      await _initPrefs();
      return _prefs!.getBool(key);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      await _initPrefs();
      return await _prefs!.remove(key);
    } catch (e) {
      return false;
    }
  }
}
