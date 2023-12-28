import 'package:flutter/material.dart';
import 'package:scored/models/config_model.dart';
import 'package:scored/models/score_model.dart';
import 'package:scored/models/state.dart';
import 'package:scored/models/user_model.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'user_form_widget.dart';
import 'models/user.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  final Database db;
  final PersistedState? state;

  const HomeScreen({super.key, required this.db, required this.state});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _userSubmit() {
    User? user = userFormSubmit.call();
    if (user != null) {
      setState(() {
        user.id = users.length;
        users.add(user);
        if (_ranked) {
          _determineRanks();
        }
        _setUser(user);
      });
      Navigator.pop(context);
    }
  }

  void _pointsSubmit(int activeUserIndex) {
    int? points = scoreFormSubmit.call();
    if (points != null) {
      setState(() {
        users[activeUserIndex].score += points;
        if (_ranked) {
          _determineRanks();
        }
        _setUser(users[activeUserIndex]);
      });
      Navigator.pop(context);
    }
  }

  void _determineRanks() {
    users.sort((userA, userB) {
      if (_reversed) {
        return userA.score.compareTo(userB.score);
      }
      return userB.score.compareTo(userA.score);
    });
    if (users.isEmpty) {
      return;
    }

    _topScore = users[0].score;
    int lastScore = users[0].score;
    int rank = 1;
    for (var user in users) {
      // Only increase rank if the new score is different
      bool cond = _reversed ? user.score > lastScore : user.score < lastScore;
      if (cond) {
        rank += 1;
        user.rank = rank;
        lastScore = user.score;
        continue;
      }

      user.rank = rank;
    }
  }

  void _setRanked(bool ranked) {
    if (ranked) {
      setState(() {
        _ranked = true;
        _determineRanks();
      });
    } else {
      setState(() {
        _ranked = false;
        users.sort((userA, userB) => userA.id.compareTo(userB.id));
      });
    }
    _setConfig();
  }

  void _reverse() {
    if (_ranked) {
      setState(() {
        _reversed = !_reversed;
        _determineRanks();
      });
    } else {
      setState(() {
        _reversed = !_reversed;
      });
    }
    _setConfig();
  }

  void _setConfig() async {
    int rankedInt = _ranked ? 1 : 0;
    int reversedInt = _reversed ? 1 : 0;
    ConfigModel model =
        ConfigModel(id: 0, ranked: rankedInt, reversed: reversedInt, pages: 0);
    await widget.db.insert('config', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _setUser(User user) async {
    UserModel userModel = UserModel(userId: user.id, name: user.name);
    ScoreModel scoreModel =
        ScoreModel(page: 0, userId: user.id, score: user.score);
    await widget.db.insert('users', userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await widget.db.insert('scores', scoreModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _deleteUser(int index) {
    int id = users[index].id;

    _removeUserRows(id);

    setState(() {
      users.removeAt(index);
    });

    Navigator.pop(context);
    _determineRanks();
  }

  void _removeUserRows(int id) async {
    await widget.db.delete("users", where: "userId = ?", whereArgs: [id]);
    await widget.db.delete("scores", where: "userId = ?", whereArgs: [id]);
  }

  void _clearTables() async {
    await widget.db.delete("users");
    await widget.db.delete("scores");
  }

  void _clearScores() {
    setState(() {
      users = [];
    });
    _clearTables();
    Navigator.pop(context);
  }

  void _resetScores() async {
    setState(() {
      for (var user in users) {
        user.score = 0;
        user.rank = 1;
      }
    });
    _determineRanks();
    widget.db.rawUpdate('UPDATE scores SET score = 0');
    Navigator.pop(context);
  }

  void _cancel() {
    Navigator.pop(context);
  }

  late User? Function() userFormSubmit;
  late int? Function() scoreFormSubmit;
  List<User> users = [];
  bool _ranked = false;
  int _topScore = 0;
  bool _reversed = false;

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      _ranked = widget.state?.config?.ranked == 1 ? true : false;
      _reversed = widget.state?.config?.reversed == 1 ? true : false;
      users = widget.state!.users;
      _determineRanks();
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scored'),
      ),
      body: Column(
        children: [
          Semantics(
            label: locale.semanticListControls,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 8,
                    children: [
                      Semantics(
                        button: true,
                        child: InputChip(
                            isEnabled: users.isNotEmpty,
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
                            isEnabled: users.isNotEmpty,
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
                        selected: _ranked,
                        onSelected: _setRanked,
                      ),
                      Semantics(
                        label: _reversed
                            ? locale.semanticsReverseDesc
                            : locale.semanticsReverseAsc,
                        button: true,
                        child: ActionChip(
                            onPressed: _ranked ? _reverse : null,
                            label: Semantics(
                                excludeSemantics: true, child: const Text("")),
                            avatar: (() {
                              if (_reversed) {
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
                  semanticChildCount: users.length,
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    User activeUser = users[index];
                    return Semantics(
                      // onTap: locale.semanticAddPoints,
                      // onLongPress: locale.semanticRemovePlayer,
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                  spacing: 16,
                                  children: [
                                    if (_ranked)
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
                            if (_ranked) {
                              if (activeUser.score == _topScore) {
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
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: const EdgeInsets.all(16.0),
                  title: Text(locale.addPlayer),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UserFormWidget(
                          builder: (context, submitFunction) {
                            userFormSubmit = submitFunction;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: _cancel, child: Text(locale.cancel)),
                    TextButton(onPressed: _userSubmit, child: Text(locale.add))
                  ],
                );
              },
            );
          },
          label: Text(locale.addPlayer),
          icon: const Icon(Icons.add)),
    );
  }
}
