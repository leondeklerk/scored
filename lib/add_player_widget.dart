import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scored/action_button_text.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/models/user.dart';
import 'package:scored/score_sheet.dart';
import 'package:scored/user_form_widget.dart';
import 'package:uuid/uuid.dart';

class AddPlayerWidget extends StatelessWidget {
  const AddPlayerWidget({
    super.key,
    required this.locale,
    required this.pageId,
    required this.widget,
    required this.enabled,
  });

  final AppLocalizations locale;
  final int pageId;
  final ScoreSheet widget;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: locale.addPlayer,
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        // color: Theme.of(context).colorScheme.secondaryContainer,
        child: ListTile(
          enabled: enabled,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 8),
              ActionButtonText(text: locale.addPlayer),
              // Add spacing between the text and the icon:
            ],
          ),
          onTap: enabled
              ? () {
                  // new order is the hightest current order + 1:
                  int order = 0;
                  if (widget.users.isNotEmpty) {
                    order = widget.users
                            .map((User user) => user.order)
                            .reduce(max) +
                        1;
                  }
                  User model =
                      User(name: "", id: const Uuid().v4(), order: order);
                  UserFormWidget.showUserFormDialog(context, locale, model, () {
                    widget.addUser(pageId, model);
                  });
                }
              : null,
        ),
      ),
    );
  }
}
