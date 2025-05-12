import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_settings_model.dart';

class Settings extends ChangeNotifier {
  static const Color defaultColor = Color(0xFF673AB7);

  Color _baseColor = defaultColor;

  final AppSettingsModel _settings;

  ThemeMode get themeMode => _settings.themeMode;

  ThemeData get lightTheme => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
            seedColor: _settings.seedColor, brightness: Brightness.light),
      );

  ThemeData get darkTheme => ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _settings.seedColor,
          brightness: Brightness.dark,
        ),
      );

  bool get useCustomTheme => _settings.useCustomTheme;

  Color get seedColor => _settings.seedColor;

  Color get baseColor => _baseColor;

  Locale get locale => _settings.locale;

  bool get showNextRoundConfirmDialog => _settings.showNextRoundConfirmDialog;

  Settings(this._settings) {
    _baseColor = _settings.seedColor;
  }

  Future<void> saveSettings() async {
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seed_color', seedColor.toARGB32());
    await prefs.setBool('is_custom_theme', useCustomTheme);
    await prefs.setString(
        'theme_mode', AppSettingsModel.themeModeToString(themeMode));
    await prefs.setString('locale', locale.languageCode);
    await prefs.setBool(
        'show_next_round_confirm_dialog', showNextRoundConfirmDialog);
  }

  void setUseCustomTheme(bool value) {
    _settings.useCustomTheme = value;
    saveSettings();
  }

  void updateTheme(Color newColor) {
    _settings.seedColor = newColor;
    saveSettings();
  }

  void setBaseColor(Color newColor) {
    _baseColor = newColor;
  }

  void setThemeMode(ThemeMode mode) {
    _settings.themeMode = mode;
    saveSettings();
  }

  void setLocale(String newLocale) {
    _settings.locale = Locale(newLocale);
    saveSettings();
  }

  void setShowNextRoundConfirmDialog(bool value) {
    _settings.showNextRoundConfirmDialog = value;
    saveSettings();
  }
}
