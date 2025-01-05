import 'package:flutter/material.dart';
import 'package:scored/confirm_dialog.dart';
import 'package:scored/models/user.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/user_rename_form_widget.dart';

class UserEditTile extends StatelessWidget {
  final AppLocalizations locale;
  final bool ranked;
  final User activeUser;
  final int topScore;
  final int index;
  final int pageId;
  final void Function(int index) deleteUser;
  final void Function(int points) setScore;
  final void Function(User model) renameUser;

  const UserEditTile({
    super.key,
    required this.locale,
    required this.ranked,
    required this.activeUser,
    required this.topScore,
    required this.index,
    required this.pageId,
    required this.deleteUser,
    required this.setScore,
    required this.renameUser,
  });

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        horizontalTitleGap: 0,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Semantics(
            label: locale.semanticEditName,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0), // Adjust the ra
              onTap: () {
                UserRenameFormWidget.showUserRenameDialog(
                    context, locale, activeUser, (User model) {
                  renameUser(model);
                });
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  activeUser.name,
                ),
              ),
            ),
          ),
          Semantics(
            label: locale.semanticEditScore,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.0), // Adjust the ra
              onTap: () {
                PointsFormWidget.showPointsDialog(
                    context,
                    activeUser.score,
                    locale,
                    locale.setPointsUser(activeUser.name),
                    locale.set, (int points) {
                  setScore(points);
                });
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  "${activeUser.score}",
                ),
              ),
            ),
          ),
        ]),
        leading: ReorderableDragStartListener(
          index: index,
          child: Semantics(
            label: locale.semanticReorder,
            child: IconButton(
              icon: const Icon(Icons.drag_indicator),
              onPressed: () {},
            ),
          ),
        ),
        trailing: Semantics(
          label: locale.semanticRemovePlayer,
          child: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ConfirmDialog.show(
                context: context,
                locale: locale,
                title: locale.deleteUser(activeUser.name),
                content: locale.deletePrompt,
                confirmText: locale.delete,
                onConfirm: () {
                  deleteUser(index);
                },
              );
            },
          ),
        ));
  }
}
