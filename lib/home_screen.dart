import 'package:flutter/material.dart';
import 'package:scored/points_form_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'user_form_widget.dart';
import 'models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      });
      Navigator.pop(context);
    }
  }

  void _determineRanks() {
    users.sort((userA, userB) => userB.score.compareTo(userA.score));
    if (users.isEmpty) {
      return;
    }

    _topScore = users[0].score;
    int lastScore = users[0].score;
    int rank = 1;
    for (var user in users) {
      if (user.score < lastScore) {
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
  }

  late User? Function() userFormSubmit;
  late int? Function() scoreFormSubmit;
  List<User> users = [];
  bool _ranked = false;
  int _topScore = 0;

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scored'),
      ),
      body: Column(
        children: [
          Wrap(alignment: WrapAlignment.spaceEvenly, spacing: 8, children: [
            InputChip(
                isEnabled: users.isNotEmpty,
                label: Text(locale.clear),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            semanticLabel: locale.semanticClearDialog,
                            title: Text(locale.clearTitle),
                            content: Text(locale.clearPrompt),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(locale.cancel)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      users = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(locale.clearButton))
                            ]);
                      });
                }),
            InputChip(
                isEnabled: users.isNotEmpty,
                label: Text(locale.resetScores),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            semanticLabel: locale.semanticResetDialog,
                            title: Text(locale.resetScores),
                            content: Text(locale.resetScoresPrompt),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(locale.cancel)),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      for (var user in users) {
                                        user.score = 0;
                                        user.rank = 1;
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(locale.reset))
                            ]);
                      });
                }),
            FilterChip(
              label: Text(locale.ranked),
              selected: _ranked,
              onSelected: _setRanked,
            )
          ]),
          const Divider(),
          Expanded(
            child: ListView.builder(
                semanticChildCount: users.length,
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  User activeUser = users[index];
                  return Card(
                    semanticContainer: true,
                    elevation: 4,
                    child: ListTile(
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                spacing: 16,
                                children: [
                                  if (_ranked) Text("${activeUser.rank}.", semanticsLabel: locale.semanticRank),
                                  Text(activeUser.name, semanticsLabel: locale.semanticName),
                                ],
                              ),
                              Text("${activeUser.score}", semanticsLabel: locale.semanticScore)
                            ]),
                        trailing: _ranked && activeUser.score == _topScore
                            ? Icon(Icons.star, color: Colors.amber, semanticLabel: locale.semanticRankIcon)
                            : null,
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    semanticLabel:
                                        locale.semanticDeleteUserDialog(
                                            activeUser.name),
                                    title: Text(
                                        locale.deleteUser(activeUser.name)),
                                    content: Text(locale.deletePrompt),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(locale.cancel)),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              users.removeAt(index);
                                            });
                                            Navigator.pop(context);
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
                                  semanticLabel: locale.semanticAddPoints,
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
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(locale.cancel)),
                                    TextButton(
                                        onPressed: () {
                                          _pointsSubmit(index);
                                        },
                                        child: Text(locale.add))
                                  ],
                                );
                              });
                        }),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  semanticLabel: locale.semanticAddUser,
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
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(locale.cancel)),
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
