import 'package:flutter/material.dart';
import 'package:scored/models/config.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  const ScoreSheet({
    super.key,
    required this.db,
    required this.pageId,
    required this.onSubmitFunction,
    required this.setConfig,
    required this.config,
    required this.users,
    required this.addUser,
    required this.resetScores,
    required this.deleteUser,
    required this.clearState,
    required this.addScore,
    required this.topScore,
  });

  final ScoreSheetSubmit onSubmitFunction;

  @override
  State<ScoreSheet> createState() => _ScoreSheetState();
}

class _ScoreSheetState extends State<ScoreSheet> {
  void _userSubmit(User user) {
    user.id = "$pageId-${widget.users.length}";
    widget.addUser(pageId, user);
    Navigator.pop(context);
  }

  void _pointsSubmit(int activeUserIndex) {
    int? points = scoreFormSubmit.call();
    if (points != null) {
      widget.addScore(pageId, activeUserIndex, points);
      Navigator.pop(context);
    }
  }

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

  late User? Function() userFormSubmit;
  late int? Function() scoreFormSubmit;
  int pageId = 0;

  @override
  void initState() {
    super.initState();
    pageId = widget.pageId;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    widget.onSubmitFunction.call(pageId, _userSubmit);

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
                      label: Text(locale.clear),
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
                      label: Text(locale.resetScores),
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
                  label: Text(locale.ranked,
                      semanticsLabel: locale.semanticRanked),
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
                semanticChildCount: widget.users.length,
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: widget.users.length,
                itemBuilder: (BuildContext context, int index) {
                  User activeUser = widget.users[index];
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
                                    child: Text(activeUser.name),
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
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  insetPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                      locale.addPointsUser(activeUser.name)),
                                  content: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        PointsFormWidget(
                                          builder: (context, submitFunction) {
                                            scoreFormSubmit = submitFunction;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: _cancel,
                                        child: Text(locale.cancel)),
                                    TextButton(
                                        onPressed: () {
                                          _pointsSubmit(index);
                                        },
                                        child: Text(locale.add))
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
