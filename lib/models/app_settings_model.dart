import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsModel {
  Color seedColor;
  bool useCustomTheme;
  ThemeMode themeMode;

  AppSettingsModel({
    this.seedColor = const Color(0xFF673AB7),
    this.useCustomTheme = false,
    this.themeMode = ThemeMode.system,
  });

  static Future<AppSettingsModel> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    AppSettingsModel appSettings = AppSettingsModel(
      seedColor: Color(prefs.getInt('seed_color') ?? 0xFF673AB7),
      useCustomTheme: prefs.getBool('is_custom_theme') ?? false,
      themeMode: getThemeMode(prefs.getString('theme_mode') ?? 'system'),
    );

    return appSettings;
  }

  static ThemeMode getThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
