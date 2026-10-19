import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:customer_core/src/core/constants/app_identifiers.dart';

class AppThemeSharedPrefs {
  static String kUserPrefsKey = "${AppIdentifiers.kBuildIdentifier}/app_theme";

  static Future<bool> clearAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .remove(kUserPrefsKey)
        .then((_) => true)
        .catchError((_) => false);
  }

  static Future<ThemeMode?> getAppTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString(kUserPrefsKey);

      return value != null ? ThemeMode.values.byName(value) : null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> saveAppTheme(ThemeMode value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(kUserPrefsKey, value.name);

      return true;
    } catch (_) {
      return false;
    }
  }
}
