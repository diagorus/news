import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static final PreferencesManager _singleton =
      new PreferencesManager._internal();

  factory PreferencesManager() => _singleton;

  PreferencesManager._internal();

  Future<bool> storeLanguageCode(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('languageCode', languageCode);
  }

  Future<String> restoreLanguageCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCode');
  }
}
