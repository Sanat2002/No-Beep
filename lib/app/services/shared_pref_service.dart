import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static Future<void> setBool(String key, bool value) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(key) ?? false;
  }
}
