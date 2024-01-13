import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scored/models/config.dart';
import 'package:scored/models/config_model.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/page_form_widget.dart';
import 'package:scored/page_rename_form_widget.dart';
import 'package:scored/score_sheet.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

import 'models/score_model.dart';
import 'models/user_model.dart';
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
      sheetUserSubmitFunctions[controller.page]?.call(user);
    }
  }

  late User? Function() userFormSubmit;
  late String? Function() pageFormSubmit;
  late PageModel? Function() pageRenameFormSubmit;
  Map<int, void Function(User user)> sheetUserSubmitFunctions = {};
  Map<int, Config?> configs = {0: null};
  Map<int, List<User>> userLists = {0: []};
  List<PageModel> pages = [];
  PageController controller = PageController(initialPage: 0);
  Map<int, int> topScores = {};
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);

  void _addPage() async {
    String? name = pageFormSubmit.call();
    var id = _nextPageId();

    name ??= id.toString();

    var model = PageModel(id: id, name: name);
    await widget.db.insert('pages', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    setState(() {
      configs[id] = null;
      userLists[id] = [];
      topScores[id] = 0;
      pages.add(model);
    });
    controller.animateToPage(pages.length - 1,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void _deletePage(int pageId, int index) async {
    setState(() {
      configs[pageId] = null;
      userLists[pageId] = [];
      topScores[pageId] = 0;
      pages.removeAt(index);
    });

    await widget.db.delete("users", where: "pageId = ?", whereArgs: [pageId]);
    await widget.db.delete("scores", where: "pageId = ?", whereArgs: [pageId]);
    await widget.db.delete("config", where: "pageId = ?", whereArgs: [pageId]);
    await widget.db.delete("pages", where: "id = ?", whereArgs: [pageId]);
  }

  int _nextPageId() {
    if (pages.isEmpty) {
      return 0;
    }

    return pages.map((page) {
          return page.id;
        }).reduce(max) +
        1;
  }

  void _renamePage(int index) async {
    PageModel? model = pageRenameFormSubmit.call();
    if (model == null) {
      return;
    }

    await widget.db.insert('pages', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    setState(() {
      pages[index] = model;
    });
  }

  String capitalizeFirst(String value) {
    if (value.trim().isEmpty) return "";
    if (value.length == 1) {
      return value.toUpperCase();
    }

    return "${value[0].toUpperCase()}${value.substring(1)}";
  }

  void _storeConfig(Config config) async {
    int rankedInt = config.ranked ? 1 : 0;
    int reversedInt = config.reversed ? 1 : 0;
    ConfigModel model = ConfigModel(
        ranked: rankedInt, reversed: reversedInt, pageId: config.pageId);
    await widget.db.insert('config', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _determineOrder(int pageId) {
    var users = userLists[pageId];
    if (users == null || users.isEmpty) {
      return;
    }

    var config = Config(ranked: false, reversed: false, pageId: pageId);
    if (configs[pageId] != null) {
      config = configs[pageId]!;
    }

    if (!config.ranked) {
      users.sort((userA, userB) => userA.id.compareTo(userB.id));
      return;
    }

    users.sort((userA, userB) {
      if (config.reversed) {
        return userA.score.compareTo(userB.score);
      }
      return userB.score.compareTo(userA.score);
    });

    topScores[pageId] = users[0].score;

    int lastScore = users[0].score;
    int rank = 1;
    for (var user in users) {
      // Only increase rank if the new score is different
      bool cond =
          config.reversed ? user.score > lastScore : user.score < lastScore;
      if (cond) {
        rank += 1;
        user.rank = rank;
        lastScore = user.score;
        continue;
      }

      user.rank = rank;
    }
  }

  void _storeUser(int pageId, User user) async {
    UserModel userModel =
    UserModel(id: user.id, name: user.name, pageId: pageId);
    ScoreModel scoreModel =
    ScoreModel(pageId: pageId, userId: user.id, score: user.score);
    await widget.db.insert('users', userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await widget.db.insert('scores', scoreModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void createInitialPage(String defaultPageName) {
    pageFormSubmit = () {
      return defaultPageName;
    };
    _addPage();
  }

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      configs = widget.state!.configs;
      widget.state!.users.forEach((key, value) {
        userLists[key] = value.values.toList();
        topScores[key] = 0;
        _determineOrder(key);
      });

      pages = widget.state!.pages;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    if (pages.isEmpty) {
      createInitialPage(locale.standardPageName);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scored')),
      body: Column(
        children: [
          Center(
              child: Visibility(
                maintainState: true,
                maintainSize: true,
                maintainAnimation: true,
                visible: pages.length > 1,
                child: CirclePageIndicator(
            currentPageNotifier: _pageNotifier,
            itemCount: pages.length,
          ),
              )),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  _pageNotifier.value = index;
                });
              },
              children: [
                for (var (index, page) in pages.indexed)
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(
                                    left: 16, bottom: 8, right: 0, top: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                foregroundColor: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                                textStyle: TextStyle(
                                    fontWeight: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.fontWeight)),
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(16.0),
                                    title: Text(locale.renamePage),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          PageRenameFormWidget(
                                            builder: (context, submitFunction) {
                                              pageRenameFormSubmit =
                                                  submitFunction;
                                            },
                                            baseModel: page,
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
                                            _renamePage(index);
                                            Navigator.pop(context);
                                          },
                                          child: Text(locale.rename))
                                    ],
                                  );
                                },
                              );
                            },
                            onLongPress: () {
                              if (pages.length == 1) {
                                return;
                              }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text(locale.deletePage(page.name)),
                                        content: Text(locale.pageDeletePrompt),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(locale.cancel)),
                                          TextButton(
                                              onPressed: () {
                                                _deletePage(page.id, index);
                                                Navigator.pop(context);
                                              },
                                              child: Text(locale.delete))
                                        ]);
                                  });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: () {
                                if (page.name == page.id.toString()) {
                                  return Text("${locale.page} ${(1 + index)}",
                                      style: const TextStyle(fontSize: 18));
                                }
                                return Text(capitalizeFirst(page.name),
                                    style: const TextStyle(fontSize: 18));
                              }(),
                            ),
                          )),
                          Visibility(
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            visible: index == pages.length - 1,
                            child: IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        insetPadding:
                                            const EdgeInsets.all(16.0),
                                        title: Text(locale.addPage),
                                        content: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              PageFormWidget(
                                                builder:
                                                    (context, submitFunction) {
                                                  pageFormSubmit =
                                                      submitFunction;
                                                },
                                                initialName:
                                                    "${locale.page} ${pages.length + 1}",
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
                                                _addPage();
                                                Navigator.pop(context);
                                              },
                                              child: Text(locale.add))
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.add)),
                          )
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Divider(
                            height: 1,
                          )),
                      Expanded(
                        child: ScoreSheet(
                          db: widget.db,
                          users: userLists[page.id]!,
                          pageId: page.id,
                          onSubmitFunction: (pageId, sheetUserSubmitFunction) {
                            sheetUserSubmitFunctions[pageId] =
                                sheetUserSubmitFunction;
                          },
                          setConfig: (configData) {
                            setState(() {
                              configs[configData.pageId] = configData;
                              _determineOrder(configData.pageId);
                            });
                            _storeConfig(configData);
                          },
                          config: () {
                            if (configs[page.id] == null) {
                              return Config(
                                  ranked: false,
                                  reversed: false,
                                  pageId: page.id);
                            } else {
                              return configs[page.id]!;
                            }
                          }(),
                          addUser: (pageId, user) {
                            setState(() {
                              userLists[pageId]?.add(user);
                              _storeUser(pageId, user);
                              _determineOrder(pageId);
                            });
                          },
                          clearState: (pageId) {
                            setState(() {
                              userLists[pageId] = [];
                            });
                          },
                          deleteUser: (pageId, userIndex) {
                            setState(() {
                              userLists[pageId]?.removeAt(userIndex);
                              _determineOrder(pageId);
                            });
                          },
                          resetScores: (pageId) {
                            var list = userLists[pageId];
                            if (list == null) {
                              return;
                            }
                            setState(() {
                              for (var user in list) {
                                user.score = 0;
                                user.rank = 1;
                              }
                              _determineOrder(pageId);
                            });
                          },
                          addScore: (pageId, userIndex, points) {
                            var list = userLists[pageId];
                            if (list == null) {
                              return;
                            }
                            setState(() {
                              list[userIndex].score += points;
                              _storeUser(pageId, list[userIndex]);
                              _determineOrder(pageId);
                            });
                          },
                          topScore: topScores[page.id]!,
                        ),
                      ),
                    ],
                  )

                //
              ],
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
