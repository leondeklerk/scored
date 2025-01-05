import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/action_button_text.dart';

class ConfirmDialog {
  static void show(
      {required BuildContext context,
      required AppLocalizations locale,
      required String title,
      required String content,
      Function? onConfirm,
      Function? onCancel,
      String? confirmText,
      String? cancelText}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: const EdgeInsets.all(16.0),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onCancel?.call();
                Navigator.of(context).pop();
              },
              child: ActionButtonText(text: cancelText ?? locale.cancel),
            ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.of(context).pop();
              },
              child: ActionButtonText(text: confirmText ?? locale.confirm),
            ),
          ],
        );
      },
    );
  }
}
