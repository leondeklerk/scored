import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsModel {
  Color seedColor;
  bool useCustomTheme;
  ThemeMode themeMode;
  Locale locale;
  bool showNextRoundConfirmDialog;
  bool useRounds;

  AppSettingsModel({
    this.seedColor = const Color(0xFF673AB7),
    this.useCustomTheme = false,
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('en'),
    this.showNextRoundConfirmDialog = true,
    this.useRounds = true,
  });

  static Future<AppSettingsModel> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    AppSettingsModel appSettings = AppSettingsModel(
      seedColor: Color(prefs.getInt('seed_color') ?? 0xFF673AB7),
      useCustomTheme: prefs.getBool('is_custom_theme') ?? false,
      themeMode: getThemeMode(prefs.getString('theme_mode') ?? 'system'),
      locale: Locale(prefs.getString('locale') ??
          ui.PlatformDispatcher.instance.locale.languageCode),
      showNextRoundConfirmDialog:
          prefs.getBool('show_next_round_confirm_dialog') ?? true,
      useRounds: prefs.getBool('use_rounds') ?? true,
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
