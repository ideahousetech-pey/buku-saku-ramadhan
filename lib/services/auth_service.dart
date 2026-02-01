import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future login(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("login_user", name);
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_user");
  }
}
