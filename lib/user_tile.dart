import 'package:flutter/material.dart';
import 'package:scored/confirm_dialog.dart';
import 'package:scored/models/user.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserTile extends StatelessWidget {
  final AppLocalizations locale;
  final bool ranked;
  final User activeUser;
  final int topScore;
  final int index;
  final int pageId;
  final void Function(int index) deleteUser;
  final void Function(int pageId, int index, int points) addScore;

  UserTile({
    required this.locale,
    required this.ranked,
    required this.activeUser,
    required this.topScore,
    required this.index,
    required this.pageId,
    required this.deleteUser,
    required this.addScore,
  });

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Wrap(
          spacing: 16,
          children: [
            if (ranked)
              Semantics(
                  label: locale.semanticRank,
                  child: Text("${activeUser.rank}.")),
            Semantics(
              label: locale.semanticName,
              child: Text(capitalizeFirstLetter(activeUser.name)),
            ),
          ],
        ),
        Semantics(
            label: locale.semanticScore, child: Text("${activeUser.score}"))
      ]),
      trailing: (() {
        if (ranked) {
          if (activeUser.score == topScore) {
            return Semantics(
                excludeSemantics: true,
                child: const Icon(Icons.star, color: Colors.amber));
          }
          return Semantics(excludeSemantics: true, child: const Icon(null));
        }
        return null;
      })(),
      onLongPress: () {
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
      onTap: () {
        PointsFormWidget.showPointsDialog(context, 0, locale,
            locale.addPointsUser(activeUser.name), locale.add, (int points) {
          addScore(pageId, index, points);
        });
      },
    );
  }
}
