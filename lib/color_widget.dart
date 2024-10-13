import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/theme_notifier.dart';
import 'action_button_text.dart';

class ColorWidget {
  static void showColorDialog(BuildContext context, AppLocalizations locale,
      SettingsNotifier notifier) {

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(locale.selectColorTitle),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Show the color picker in sized box in a raised card.
                ColorPicker(
                  // Use the screenPickerColor as start and active color.
                  color: notifier.seedColor,
                  // Update the screenPickerColor using the callback.
                  onColorChanged: notifier.updateTheme,
                  borderRadius: 22,
                  heading: Text(locale.selectColor),
                  subheading: Text(locale.selectColorShade),
                  showColorName: true,
                  showColorCode: true,
                  enableTonalPalette: false,
                  enableShadesSelection: true,

                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.primary: true,
                    ColorPickerType.accent: false,
                    ColorPickerType.wheel: false,
                    ColorPickerType.custom: true,
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  notifier.updateTheme(SettingsNotifier.defaultColor);
                },
                child: ActionButtonText(text: locale.reset)),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  notifier.updateTheme(notifier.baseColor);
                },
                child: ActionButtonText(text: locale.cancel)),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  notifier.setBaseColor(notifier.seedColor);
                },
                child: ActionButtonText(text: locale.select))
          ],
        );
      },
    );
  }
}
