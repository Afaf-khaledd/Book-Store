import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  SharedPreference._privateConstructor();
  static final SharedPreference _instance = SharedPreference._privateConstructor();
  factory SharedPreference() {
    return _instance;
  }

  Future<void> setRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  Future<bool> getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }
  Future<void> setIsAdmin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAdmin', value);
  }

  Future<bool> getIsAdmin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdmin') ?? false;
  }
}