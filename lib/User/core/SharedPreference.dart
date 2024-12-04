import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference{
  SharedPreference._privateConstructor();
  static final SharedPreference instance = SharedPreference._privateConstructor();

  Future<void> setRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  Future<bool> getRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }

  Future<void> setDataLoaded(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dataLoaded', value);
  }

  Future<bool> getDataLoaded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dataLoaded') ?? false;
  }
}