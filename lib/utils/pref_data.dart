import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static Future<bool> getIntro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isIntro') ?? false;
  }

  static Future<bool> getLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  static Future<void> setIntro(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIntro', value);
  }

  static Future<void> setLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', value);
  }
}
