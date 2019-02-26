import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String KEY_FORUMS = 'KEY_FORUMS';

  static Future<SharedPreferences> getInstance() async =>
      await SharedPreferences.getInstance();
}
