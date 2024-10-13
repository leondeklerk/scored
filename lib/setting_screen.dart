import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/color_widget.dart';
import 'package:scored/theme_notifier.dart';

import 'action_button_text.dart';

class SettingScreen {
  static void showSettings(BuildContext context, AppLocalizations locale,
      SettingsNotifier notifier) {
    List<bool> isSelected = [
      notifier.themeMode == ThemeMode.light,
      notifier.themeMode == ThemeMode.dark,
      notifier.themeMode == ThemeMode.system,
    ];

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(locale.settingsTitle),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.settingGroupThemeTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 2,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.settingThemeModeTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                      }
                      switch (index) {
                        case 0:
                          notifier.setThemeMode(ThemeMode.light);
                          break;
                        case 1:
                          notifier.setThemeMode(ThemeMode.dark);
                          break;
                        case 2:
                          notifier.setThemeMode(ThemeMode.system);
                          break;
                      }
                    },
                    borderRadius: BorderRadius.circular(16.0),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ActionButtonText(text: locale.settingThemeModeLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ActionButtonText(text: locale.settingThemeModeDark),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ActionButtonText(text: locale.settingThemeModeAuto),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       locale.settingsCustomColorMode,
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //     Switch(
              //       value: notifier.useCustomTheme,
              //       onChanged: (bool value) {
              //         notifier.setUseCustomTheme(value);
              //       },
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.settingBaseColor,
                    style:  Theme.of(context).textTheme.bodyLarge
                  ),
                  GestureDetector(
                    onTap: () {
                      ColorWidget.showColorDialog(context, locale, notifier);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: notifier.seedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
