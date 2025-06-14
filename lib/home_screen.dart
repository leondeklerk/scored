import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scored/confirm_dialog.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/models/config.dart';
import 'package:scored/models/config_model.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/round.dart';
import 'package:scored/models/state.dart';
import 'package:scored/page_form_widget.dart';
import 'package:scored/page_rename_form_widget.dart';
import 'package:scored/score_sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'models/round_model.dart';
import 'models/score_model.dart';
import 'models/user.dart';
import 'models/user_model.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  final Database db;
  final PersistedState? state;
  final bool useRounds;

  const HomeScreen(
      {super.key,
      required this.db,
      required this.state,
      required this.useRounds});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<int, Config?> configs = {0: null};
  Map<int, List<User>> userLists = {0: []};
  List<PageModel> pages = [];
  PageController controller = PageController(initialPage: 0);
  Map<int, int> topScores = {};
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  bool _editMode = false;

  void _setEditMode(bool value, int? pageId) {
    setState(() {
      _editMode = value;
    });

    if (pageId != null) {
      _storeUsers(pageId);
      _determineOrder(pageId);
    }
  }

  void _setUsers(List<User> users, int pageId) {
    userLists[pageId] = users;
    _determineOrder(pageId);
  }

  void _addPage(String? name) async {
    var id = _nextPageId();

    name ??= id.toString();

    var order = _nextOrder();

    var index = 0;
    if (pages.isNotEmpty) {
      index = _pageNotifier.value + 1;
    }

    var model = PageModel(id: id, name: name, order: order, currentRound: 1);
    await widget.db.insert('pages', model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
    setState(() {
      widget.state!.rounds[id] = Round(
        id: const Uuid().v4(),
        number: 1,
        scores: {},
      );
      configs[id] = null;
      userLists[id] = [];
      topScores[id] = 0;
      pages.insert(index, model);
    });
    controller.animateToPage(_pageNotifier.value + 1,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300));
  }

  void _deletePage(int pageId, int index) async {
    if (index != 0) {
      await controller.animateToPage(index - 1,
          curve: Curves.easeIn, duration: const Duration(milliseconds: 200));
    }

    setState(() {
      configs[pageId] = null;
      userLists[pageId] = [];
      topScores[pageId] = 0;
      pages.removeAt(index);
    });

    _pageNotifier.value = min(index, pages.length - 1);

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

  double _nextOrder() {
    if (pages.isEmpty) {
      return 0;
    }

    if (pages.length == 1) {
      return 1;
    }

    int newIndex = _pageNotifier.value + 1;
    if (newIndex == pages.length) {
      return pages.last.order + 1;
    }

    return (pages[newIndex - 1].order + pages[newIndex].order) / 2;
  }

  void _renamePage(int index, PageModel model) async {
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
      users.sort((userA, userB) => userA.order.compareTo(userB.order));
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
    UserModel userModel = UserModel(
        id: user.id, name: user.name, pageId: pageId, order: user.order);
    ScoreModel scoreModel =
        ScoreModel(pageId: pageId, userId: user.id, score: user.score);
    await widget.db.insert('users', userModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await widget.db.insert('scores', scoreModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _storeUserRound(int pageId, String userId, Round round) async {
    RoundModel roundModel = RoundModel(
        id: round.id, number: round.number, pageId: pageId, userId: userId);

    await widget.db.insert('rounds', roundModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void _storeUsers(int pageId) async {
    var users = userLists[pageId];
    if (users == null) {
      return;
    }

    // Store many at once:
    var batch = widget.db.batch();
    for (var user in users) {
      _storeUser(pageId, user);
    }
    batch.commit();
  }

  void createInitialPage(String defaultPageName) {
    _addPage(defaultPageName);
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

      if (widget.state!.users.isEmpty) {
        for (var page in widget.state!.pages) {
          userLists[page.id] = [];
        }
      }

      pages = widget.state!.pages;
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (pages.isEmpty) {
      createInitialPage(locale.standardPageName);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Scored'),
        actions: [
          IconButton(
              onPressed: _editMode
                  ? null
                  : () {
                      SettingScreen.showSettings(context);
                    },
              icon: const Icon(Icons.tune))
        ],
      ),
      body: Column(
        children: [
          Center(
              child: Visibility(
            maintainState: true,
            maintainSize: true,
            maintainAnimation: true,
            visible: pages.length > 1,
            child: SmoothPageIndicator(
              controller: controller, // PageController
              count: pages.length,
              effect: ScrollingDotsEffect(
                maxVisibleDots: 13,
                activeDotColor: _editMode
                    ? theme.colorScheme.surfaceContainerHighest
                    : theme.colorScheme.onSurfaceVariant,
                // Use primary color for active dot
                dotColor: _editMode
                    ? theme.colorScheme.surfaceContainerLow
                    : theme.colorScheme.surfaceContainerHighest,
                dotWidth: 8,
                dotHeight: 8,
                activeDotScale: 1,
                // Color(0x509E9E9E)
              ), // Customize the effect as needed
            ),
          )),
          Expanded(
            child: PageView(
              controller: controller,
              physics: _editMode ? const NeverScrollableScrollPhysics() : null,
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
                                foregroundColor:
                                    theme.textTheme.bodyMedium
                                    ?.color,
                                textStyle: TextStyle(
                                    fontWeight: theme
                                        .textTheme
                                        .bodyMedium
                                        ?.fontWeight)),
                            onPressed: _editMode
                                ? null
                                : () {
                                    PageRenameFormWidget.showPageRenameDialog(
                                        context, locale, page,
                                        (PageModel model) {
                                      _renamePage(index, model);
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
                            visible: pages.length > 1,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainInteractivity: false,
                            maintainSize: true,
                            child: IconButton(
                                onPressed: _editMode
                                    ? null
                                    : () {
                                        if (pages.length == 1) {
                                          return;
                                        }
                                        ConfirmDialog.show(
                                            context: context,
                                            locale: locale,
                                            title: locale.deletePage(page.name),
                                            content: locale.pageDeletePrompt,
                                            onConfirm: () {
                                              _deletePage(page.id, index);
                                            },
                                            confirmText: locale.delete);
                                      },
                                icon: const Icon(Icons.close)),
                          ),
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
                          round: widget.state!.rounds[page.id]!,
                          pageId: page.id,
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
                          isEditMode: _editMode,
                          setEditMode: _setEditMode,
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

                              if (widget.useRounds) {
                                widget.state!.rounds[pageId] = Round(
                                    id: const Uuid().v4(),
                                    number:
                                        widget.state!.rounds[pageId]!.number +
                                            1,
                                    scores: {});
                              }
                            });
                          },
                          completeRound: (pageId) {
                            setState(() {
                              widget.state!.rounds[pageId] = Round(
                                  id: const Uuid().v4(),
                                  number:
                                      widget.state!.rounds[pageId]!.number + 1,
                                  scores: {});
                            });
                          },
                          addScore: (pageId, userIndex, points) {
                            var list = userLists[pageId];
                            if (list == null) {
                              return;
                            }
                            setState(() {
                              var user = list[userIndex];
                              if (user.score + points >=
                                  double.maxFinite.toInt()) {
                                user.score = double.maxFinite.toInt();
                              } else {
                                user.score += points;
                              }

                              if (widget.useRounds) {
                                widget.state!.rounds[pageId]!.scores[user.id] =
                                    0;
                              }
                              _storeUser(pageId, user);
                              if (widget.useRounds) {
                                _storeUserRound(pageId, user.id,
                                    widget.state!.rounds[pageId]!);
                              }
                              _determineOrder(pageId);
                            });
                          },
                          // setScore: (pageId, userIndex, points) {
                          //   setState(() {
                          //     userLists[pageId]![userIndex].score = points;
                          //   });
                          // },
                          setUsers: (users, pageId) => _setUsers(users, pageId),
                          updateUser: (pageId, userIndex, user) {
                            setState(() {
                              userLists[pageId]![userIndex] = user;
                            });
                          },
                          topScore: topScores[page.id]!,
                          useRounds: widget.useRounds,
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
      floatingActionButton: _editMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                PageFormWidget.showAddPageDialog(context, locale,
                    "${locale.page} - ${DateFormat('HH:mm dd/MM/yy', locale.localeName).format(DateTime.now())}",
                    (String name) {
                  _addPage(name);
                });
              },
              label: Text(locale.addPage.toUpperCase(),
                  style: const TextStyle(fontFamily: "OpenSans")),
              icon: const Icon(Icons.add)),
    );
  }
}
