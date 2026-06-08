import 'package:customer_core/customer_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:customer_core/src/application/core/base_controller.dart';
import 'package:customer_core/src/infrastructure/theme/theme_shared_prefs_repo.dart';

@LazySingleton()
class ThemeProvider extends ChangeNotifier with BaseController {

var themeMode = ThemeMode.system;

bool get isDarkMode {
  if (themeMode == ThemeMode.dark) return true;
  if (themeMode == ThemeMode.light) return false;
  // ThemeMode.system: reflect actual platform brightness
  final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return brightness == Brightness.dark;
}


  AppThemeMode? _tMode;

  void toggleTheme(ThemeMode mode) {
   themeMode = mode;
  AppThemeSharedPrefs.saveAppTheme(mode);
  notifyListeners();
}

  @override
  Future<void> init() {
    loadAppTheme();

    return super.init();
  }

Future<void> loadAppTheme() async {
  final saved = await AppThemeSharedPrefs.getAppTheme(); 
  final configMode = _mapThemeMode(AppConfig.instance.themeMode);

  if (saved == null) {
    // No saved preference → fallback to config
    themeMode = configMode;
  } else {
    themeMode = saved;
  }

  notifyListeners();
}

   ThemeMode _mapThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
