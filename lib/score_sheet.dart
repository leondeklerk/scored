import 'package:flutter/material.dart';
import 'package:scored/models/config.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/user_form_widget.dart';
import 'models/user.dart';
import 'package:sqflite/sqflite.dart';

typedef ScoreSheetSubmit = void Function(
    int pageId, void Function(User user) submitFunction);

class ScoreSheet extends StatefulWidget {
  final Database db;
  final List<User> users;
  final int pageId;
  final void Function(Config model) setConfig;
  final Config config;
  final void Function(int pageId, User user) addUser;
  final void Function(int pageId) resetScores;
  final void Function(int pageId, int userIndex) deleteUser;
  final void Function(int pageId) clearState;
  final void Function(int pageId, int userIndex, int score) addScore;
  final int topScore;

  const ScoreSheet(
      {super.key,
      required this.db,
      required this.pageId,
      required this.setConfig,
      required this.config,
      required this.users,
      required this.addUser,
      required this.resetScores,
      required this.deleteUser,
      required this.clearState,
      required this.addScore,
      required this.topScore});


  @override
  State<ScoreSheet> createState() => _ScoreSheetState();
}

class _ScoreSheetState extends State<ScoreSheet> {
  void _setRanked(bool ranked) {
    widget.setConfig(Config(
        ranked: ranked, reversed: widget.config.reversed, pageId: pageId));
  }

  void _reverse() {
    setState(() {
      widget.setConfig(Config(
          ranked: widget.config.ranked,
          reversed: !widget.config.reversed,
          pageId: pageId));
    });
  }

  void _deleteUser(int index) {
    String id = widget.users[index].id;

    _removeUserRows(id);
    widget.deleteUser(pageId, index);
    Navigator.pop(context);
  }

  void _removeUserRows(String id) async {
    await widget.db.delete("users",
        where: "id = ? and pageId = ?", whereArgs: [id, pageId]);
    await widget.db.delete("scores",
        where: "userId = ? AND pageId = ?", whereArgs: [id, pageId]);
  }

  void _clearTables() async {
    await widget.db.delete("users", where: "pageId = ?", whereArgs: [pageId]);
    await widget.db.delete("scores", where: "pageId = ?", whereArgs: [pageId]);
  }

  void _clearScores() {
    widget.clearState(pageId);
    _clearTables();
    Navigator.pop(context);
  }

  void _resetScores() async {
    widget.resetScores(pageId);
    widget.db
        .rawUpdate('UPDATE scores SET score = 0 WHERE pageId = ?', [pageId]);
    Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  int pageId = 0;

  @override
  void initState() {
    super.initState();
    pageId = widget.pageId;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return Column(
      children: [
        Semantics(
          label: locale.semanticListControls,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(alignment: WrapAlignment.spaceEvenly, spacing: 8, children: [
                Semantics(
                  button: true,
                  child: InputChip(
                      isEnabled: widget.users.isNotEmpty,
                      label: Text(
                        locale.clear.toUpperCase(),
                        style: const TextStyle(fontFamily: "OpenSans"),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(locale.clearTitle),
                                  content: Text(locale.clearPrompt),
                                  actions: [
                                    TextButton(
                                        onPressed: _cancel,
                                        child: Text(locale.cancel)),
                                    TextButton(
                                        onPressed: _clearScores,
                                        child: Text(locale.clearButton))
                                  ]);
                            });
                      }),
                ),
                Semantics(
                  button: true,
                  child: InputChip(
                      isEnabled: widget.users.isNotEmpty,
                      label: Text(
                        locale.resetScores.toUpperCase(),
                        style: const TextStyle(fontFamily: "OpenSans"),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text(locale.resetScores),
                                  content: Text(locale.resetScoresPrompt),
                                  actions: [
                                    TextButton(
                                        onPressed: _cancel,
                                        child: Text(locale.cancel)),
                                    TextButton(
                                        onPressed: _resetScores,
                                        child: Text(locale.reset))
                                  ]);
                            });
                      }),
                ),
                FilterChip(
                  label: Text(
                    locale.ranked.toUpperCase(),
                    semanticsLabel: locale.semanticRanked,
                    style: const TextStyle(fontFamily: "OpenSans"),
                  ),
                  selected: widget.config.ranked,
                  onSelected: _setRanked,
                ),
                Semantics(
                  label: widget.config.reversed
                      ? locale.semanticsReverseDesc
                      : locale.semanticsReverseAsc,
                  button: true,
                  child: ActionChip(
                      onPressed: widget.config.ranked ? _reverse : null,
                      label: Semantics(
                          excludeSemantics: true, child: const Text("")),
                      avatar: (() {
                        if (widget.config.reversed) {
                          return const Icon(Icons.keyboard_arrow_down);
                        } else {
                          return const Icon(Icons.keyboard_arrow_up);
                        }
                      })(),
                      labelPadding: EdgeInsets.zero),
                ),
              ]),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Semantics(
            label: "Player list",
            child: ListView.builder(
                semanticChildCount: widget.users.length + 1,
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: widget.users.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == widget.users.length) {
                    // Add a button that looks like a list item but uses a secondary color and is a button to add a new player
                    return Semantics(
                      label: locale.addPlayer,
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        // color: Theme.of(context).colorScheme.secondaryContainer,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add),
                              const SizedBox(width: 8),
                              Text(
                                style: const TextStyle(fontFamily: "OpenSans"),
                                locale.addPlayer.toUpperCase(),
                              ),
                              // Add spacing between the text and the icon:
                            ],
                          ),
                          onTap: () {
                            User model = User(
                                name: "", id: "$pageId-${widget.users.length}");
                            UserFormWidget.showUserFormDialog(
                                context, locale, model, () {
                              widget.addUser(pageId, model);
                            });
                          },
                        ),
                      ),
                    );
                  } else {
                    User activeUser = widget.users[index];

                    String capitalizeFirstLetter(String text) {
                      if (text.isEmpty) return text;
                      return text[0].toUpperCase() + text.substring(1);
                    }

                    return Semantics(
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  spacing: 16,
                                  children: [
                                    if (widget.config.ranked)
                                      Semantics(
                                          label: locale.semanticRank,
                                          child: Text("${activeUser.rank}.")),
                                    Semantics(
                                      label: locale.semanticName,
                                      child: Text(capitalizeFirstLetter(
                                          activeUser.name)),
                                    ),
                                  ],
                                ),
                                Semantics(
                                    label: locale.semanticScore,
                                    child: Text("${activeUser.score}"))
                              ]),
                          trailing: (() {
                            if (widget.config.ranked) {
                              if (activeUser.score == widget.topScore) {
                                return Semantics(
                                    excludeSemantics: true,
                                    child: const Icon(Icons.star,
                                        color: Colors.amber));
                              }
                              return Semantics(
                                  excludeSemantics: true,
                                  child: const Icon(null));
                            }
                            return null;
                          })(),
                          onLongPress: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(
                                          locale.deleteUser(activeUser.name)),
                                      content: Text(locale.deletePrompt),
                                      actions: [
                                        TextButton(
                                            onPressed: _cancel,
                                            child: Text(locale.cancel)),
                                        TextButton(
                                            onPressed: () {
                                              _deleteUser(index);
                                            },
                                            child: Text(locale.delete))
                                      ]);
                                });
                          },
                          onTap: () {
                            PointsFormWidget.showPointsDialog(context, locale, activeUser.name, (int points) {
                              widget.addScore(pageId, index, points);
                            });
                          },
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
