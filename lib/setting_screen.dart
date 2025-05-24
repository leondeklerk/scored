import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scored/color_widget.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/settings.dart';

import 'action_button_text.dart';

class SettingScreen {
  static void showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer<Settings>(builder: (context, notifier, child) {
          List<bool> isSelected = [
            notifier.themeMode == ThemeMode.light,
            notifier.themeMode == ThemeMode.dark,
            notifier.themeMode == ThemeMode.system,
          ];

          final locale = AppLocalizations.of(context)!;

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
                      locale.settingGroupGeneralTitle,
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
                // Language setting:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.settingLanguageTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8.0),
                        child: Builder(
                          builder: (BuildContext buttonContext) {
                            return InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              onTap: () {
                                final RenderBox button = buttonContext
                                    .findRenderObject() as RenderBox;
                                final RenderBox overlay =
                                    Overlay.of(buttonContext)
                                        .context
                                        .findRenderObject() as RenderBox;

                                final Offset buttonPosition =
                                    button.localToGlobal(Offset.zero,
                                        ancestor: overlay);
                                final Size buttonSize = button.size;

                                // Add spacing by increasing the top offset
                                const double menuPadding = 8.0;

                                showMenu<String>(
                                  context: buttonContext,
                                  position: RelativeRect.fromLTRB(
                                    buttonPosition
                                        .dx, // Left aligned with the button
                                    buttonPosition.dy +
                                        buttonSize.height +
                                        menuPadding, // Add padding here
                                    overlay.size.width -
                                        (buttonPosition.dx) -
                                        buttonSize.width,
                                    overlay.size.height -
                                        (buttonPosition.dy +
                                            buttonSize.height +
                                            menuPadding),
                                  ),
                                  items: AppLocalizations.supportedLocales
                                      .map<PopupMenuItem<String>>(
                                        (Locale locale) =>
                                            PopupMenuItem<String>(
                                          value: locale.languageCode,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Text(locale.languageCode
                                                .toUpperCase()),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Round the menu
                                  ),
                                ).then((String? result) {
                                  if (result != null) {
                                    notifier.setLocale(result);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                    notifier.locale.languageCode.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.settingUseRoundsTitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(
                      value: notifier.useRounds,
                      onChanged: (bool value) {
                        notifier.setUseRounds(value);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.settingShowNextRoundConfirmDialogTitle,
                      style: notifier.useRounds
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).disabledColor),
                    ),
                    Switch(
                      value: notifier.showNextRoundConfirmDialog,
                      onChanged: notifier.useRounds
                          ? (bool value) {
                              notifier.setShowNextRoundConfirmDialog(value);
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                          child: ActionButtonText(
                              text: locale.settingThemeModeLight),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ActionButtonText(
                              text: locale.settingThemeModeDark),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ActionButtonText(
                              text: locale.settingThemeModeAuto),
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
                    Text(locale.settingBaseColor,
                        style: Theme.of(context).textTheme.bodyLarge),
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
        });
      },
    );
  }
}
