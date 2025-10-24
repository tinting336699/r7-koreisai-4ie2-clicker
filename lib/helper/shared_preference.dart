import 'package:shared_preferences/shared_preferences.dart';

// ユーザー情報管理
class CookieManager {
  static const String _nameKey = 'username';
  static const String _idKey = 'id';

  static Future<void> saveName(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, username);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> clearName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
  }

  static Future<void> saveId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, id);
  }

  static Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  static Future<void> clearId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
  }
}
