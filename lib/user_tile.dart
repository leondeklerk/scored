import 'package:flutter/material.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/models/user.dart';
import 'package:scored/points_form_widget.dart';

class UserTile extends StatelessWidget {
  final AppLocalizations locale;
  final bool ranked;
  final User activeUser;
  final int topScore;
  final int index;
  final int pageId;
  final void Function(int pageId, int index, int points) addScore;
  final bool hasRoundEntry;

  const UserTile(
      {super.key,
      required this.locale,
      required this.ranked,
      required this.activeUser,
      required this.topScore,
      required this.index,
      required this.pageId,
      required this.addScore,
      required this.hasRoundEntry});

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: hasRoundEntry
            ? Theme.of(context).textTheme.bodyLarge?.color?.withAlpha(128)
            : null);

    return ListTile(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Wrap(
          spacing: 16,
          children: [
            if (ranked)
              Semantics(
                  label: locale.semanticRank,
                  child: Text("${activeUser.rank}.", style: textStyle)),
            Semantics(
              label: locale.semanticName,
              child: Text(capitalizeFirstLetter(activeUser.name),
                  style: textStyle),
            ),
          ],
        ),
        Semantics(
            label: locale.semanticScore,
            child: Text("${activeUser.score}", style: textStyle)),
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
      onTap: () {
        PointsFormWidget.showPointsDialog(context, 0, locale,
            locale.addPointsUser(activeUser.name), locale.add, (int points) {
          addScore(pageId, index, points);
        });
      },
    );
  }
}
