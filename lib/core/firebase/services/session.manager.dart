import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String userID = "token";

  static Future<void> saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userID, token);
  }

  static Future<void> getToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getString(userID);
  }
}
