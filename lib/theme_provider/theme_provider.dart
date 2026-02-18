// import 'package:flutter/material.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   bool isDark = true;
//
//   void toggleTheme() {
//     isDark = !isDark;
//     notifyListeners();
//   }
//
//   ThemeMode get currentTheme => isDark ? ThemeMode.dark : ThemeMode.light;
// }

import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

// class ThemeProvider extends ChangeNotifier {
//   AppThemeMode _themeMode = AppThemeMode.system;
//
//   AppThemeMode get themeMode => _themeMode;
//
//   ThemeMode get currentTheme {
//     switch (_themeMode) {
//       case AppThemeMode.light:
//         return ThemeMode.light;
//       case AppThemeMode.dark:
//         return ThemeMode.dark;
//       case AppThemeMode.system:
//       default:
//         return ThemeMode.system;
//     }
//   }
//
//   void setTheme(AppThemeMode mode) {
//     _themeMode = mode;
//     notifyListeners();
//   }
//
//   void toggleTheme() {
//     if (_themeMode == AppThemeMode.light) {
//       setTheme(AppThemeMode.dark);
//     } else if (_themeMode == AppThemeMode.dark) {
//       setTheme(AppThemeMode.light);
//     } else {
//       setTheme(AppThemeMode.light);
//     }
//   }
// }

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;

  AppThemeMode get themeMode => _themeMode;

  ThemeMode get currentTheme {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
      default:
        return ThemeMode.system;
    }
  }

  /// ✅ THIS IS THE IMPORTANT PART
  bool isDarkMode(BuildContext context) {
    if (_themeMode == AppThemeMode.dark) return true;
    if (_themeMode == AppThemeMode.light) return false;

    // system theme
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  void toggleTheme(BuildContext context) {
    final isDark = isDarkMode(context);
    _themeMode = isDark ? AppThemeMode.light : AppThemeMode.dark;
    notifyListeners();
  }
}
