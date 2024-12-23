import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_settings_model.dart';

class SettingsNotifier extends ChangeNotifier {
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

  SettingsNotifier(this._settings) {
    _baseColor = _settings.seedColor;
  }

  Future<void> saveSettings() async {
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seed_color', seedColor.value);
    await prefs.setBool('is_custom_theme', useCustomTheme);
    await prefs.setString(
        'theme_mode', AppSettingsModel.themeModeToString(themeMode));
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
}

//
// const ColorScheme _colorSchemeLightM3 = ColorScheme(
//   brightness: Brightness.light,
//   primary: Color(0xFF6750A4),
//   onPrimary: Color(0xFFFFFFFF),
//   primaryContainer: Color(0xFFEADDFF),
//   onPrimaryContainer: Color(0xFF21005D),
//   primaryFixed: Color(0xFFEADDFF),
//   primaryFixedDim: Color(0xFFD0BCFF),
//   onPrimaryFixed: Color(0xFF21005D),
//   onPrimaryFixedVariant: Color(0xFF4F378B),
//   secondary: Color(0xFF625B71),
//   onSecondary: Color(0xFFFFFFFF),
//   secondaryContainer: Color(0xFFE8DEF8),
//   onSecondaryContainer: Color(0xFF1D192B),
//   secondaryFixed: Color(0xFFE8DEF8),
//   secondaryFixedDim: Color(0xFFCCC2DC),
//   onSecondaryFixed: Color(0xFF1D192B),
//   onSecondaryFixedVariant: Color(0xFF4A4458),
//   tertiary: Color(0xFF7D5260),
//   onTertiary: Color(0xFFFFFFFF),
//   tertiaryContainer: Color(0xFFFFD8E4),
//   onTertiaryContainer: Color(0xFF31111D),
//   tertiaryFixed: Color(0xFFFFD8E4),
//   tertiaryFixedDim: Color(0xFFEFB8C8),
//   onTertiaryFixed: Color(0xFF31111D),
//   onTertiaryFixedVariant: Color(0xFF633B48),
//   error: Color(0xFFB3261E),
//   onError: Color(0xFFFFFFFF),
//   errorContainer: Color(0xFFF9DEDC),
//   onErrorContainer: Color(0xFF410E0B),
//   background: Color(0xFFFEF7FF),
//   onBackground: Color(0xFF1D1B20),
//   surface: Color(0xFFFEF7FF),
//   surfaceBright: Color(0xFFFEF7FF),
//   surfaceContainerLowest: Color(0xFFFFFFFF),
//   surfaceContainerLow: Color(0xFFF7F2FA),
//   surfaceContainer: Color(0xFFF3EDF7),
//   surfaceContainerHigh: Color(0xFFECE6F0),
//   surfaceContainerHighest: Color(0xFFE6E0E9),
//   surfaceDim: Color(0xFFDED8E1),
//   onSurface: Color(0xFF1D1B20),
//   surfaceVariant: Color(0xFFE7E0EC),
//   onSurfaceVariant: Color(0xFF49454F),
//   outline: Color(0xFF79747E),
//   outlineVariant: Color(0xFFCAC4D0),
//   shadow: Color(0xFF000000),
//   scrim: Color(0xFF000000),
//   inverseSurface: Color(0xFF322F35),
//   onInverseSurface: Color(0xFFF5EFF7),
//   inversePrimary: Color(0xFFD0BCFF),
//   // The surfaceTint color is set to the same color as the primary.
//   surfaceTint: Color(0xFF6750A4),
// );
//
// const ColorScheme _colorSchemeDarkM3 = ColorScheme(
//   brightness: Brightness.dark,
//   primary: Color(0xFFD0BCFF),
//   onPrimary: Color(0xFF381E72),
//   primaryContainer: Color(0xFF4F378B),
//   onPrimaryContainer: Color(0xFFEADDFF),
//   primaryFixed: Color(0xFFEADDFF),
//   primaryFixedDim: Color(0xFFD0BCFF),
//   onPrimaryFixed: Color(0xFF21005D),
//   onPrimaryFixedVariant: Color(0xFF4F378B),
//   secondary: Color(0xFFCCC2DC),
//   onSecondary: Color(0xFF332D41),
//   secondaryContainer: Color(0xFF4A4458),
//   onSecondaryContainer: Color(0xFFE8DEF8),
//   secondaryFixed: Color(0xFFE8DEF8),
//   secondaryFixedDim: Color(0xFFCCC2DC),
//   onSecondaryFixed: Color(0xFF1D192B),
//   onSecondaryFixedVariant: Color(0xFF4A4458),
//   tertiary: Color(0xFFEFB8C8),
//   onTertiary: Color(0xFF492532),
//   tertiaryContainer: Color(0xFF633B48),
//   onTertiaryContainer: Color(0xFFFFD8E4),
//   tertiaryFixed: Color(0xFFFFD8E4),
//   tertiaryFixedDim: Color(0xFFEFB8C8),
//   onTertiaryFixed: Color(0xFF31111D),
//   onTertiaryFixedVariant: Color(0xFF633B48),
//   error: Color(0xFFF2B8B5),
//   onError: Color(0xFF601410),
//   errorContainer: Color(0xFF8C1D18),
//   onErrorContainer: Color(0xFFF9DEDC),
//   background: Color(0xFF141218),
//   onBackground: Color(0xFFE6E0E9),
//   surface: Color(0xFF141218),
//   surfaceBright: Color(0xFF3B383E),
//   surfaceContainerLowest: Color(0xFF0F0D13),
//   surfaceContainerLow: Color(0xFF1D1B20),
//   surfaceContainer: Color(0xFF211F26),
//   surfaceContainerHigh: Color(0xFF2B2930),
//   surfaceContainerHighest: Color(0xFF36343B),
//   surfaceDim: Color(0xFF141218),
//   onSurface: Color(0xFFE6E0E9),
//   surfaceVariant: Color(0xFF49454F),
//   onSurfaceVariant: Color(0xFFCAC4D0),
//   outline: Color(0xFF938F99),
//   outlineVariant: Color(0xFF49454F),
//   shadow: Color(0xFF000000),
//   scrim: Color(0xFF000000),
//   inverseSurface: Color(0xFFE6E0E9),
//   onInverseSurface: Color(0xFF322F35),
//   inversePrimary: Color(0xFF6750A4),
//   // The surfaceTint color is set to the same color as the primary.
//   surfaceTint: Color(0xFFD0BCFF),
// );
