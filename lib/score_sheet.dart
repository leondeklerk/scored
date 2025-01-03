import 'package:flutter/material.dart';
import 'package:scored/add_player_widget.dart';
import 'package:scored/models/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scored/user_edit_tile.dart';
import 'package:scored/user_tile.dart';
import 'action_button_text.dart';
import 'confirm_dialog.dart';
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
  final void Function(int pageId, int userIndex, int score) addScore;
  final void Function(int pageId, int userIndex, User user) updateUser;
  final int topScore;
  final void Function(bool isEditMode, int? pageId) setEditMode;
  final void Function(List<User> users, int pageId) setUsers;
  final bool isEditMode;

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
      required this.addScore,
      required this.updateUser,
      required this.topScore,
      required this.setUsers,
      required this.setEditMode,
      required this.isEditMode});

  @override
  State<ScoreSheet> createState() => _ScoreSheetState();
}

class _ScoreSheetState extends State<ScoreSheet> {
  bool get _isEditMode => widget.isEditMode;
  List<User> startUsers = [];

  bool get _isDirty {
    if (_isEditMode) {
      // Check if users and startUsers are the same:
      if (widget.users.length != startUsers.length) {
        return true;
      } else {
        for (int i = 0; i < widget.users.length; i++) {
          User oldUser = startUsers[i];
          User newUser = widget.users[i];
          if (oldUser.id != newUser.id ||
              oldUser.name != newUser.name ||
              oldUser.order != newUser.order ||
              oldUser.score != newUser.score) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _toggleEditMode(bool editMode) {
    if (_isEditMode) {
      if (!_isDirty) {
        widget.setEditMode(editMode, null);
        return;
      }

      AppLocalizations locale = AppLocalizations.of(context)!;
      ConfirmDialog.show(
          context: context,
          locale: locale,
          title: locale.saveChangesTitle,
          content: locale.saveChangesContent,
          cancelText: locale.discard,
          confirmText: locale.save,
          onConfirm: () {
            // Update order of users based on current order in the array:
            for (int i = 0; i < widget.users.length; i++) {
              widget.users[i].order = i;
            }

            startUsers = [];

            widget.setEditMode(editMode, pageId);
          },
          onCancel: () {
            widget.setUsers(List<User>.from(startUsers), pageId);
            startUsers = [];
            widget.setEditMode(editMode, null);
          });

      // store all current users for now:
    } else {
      // Switching to edit mode
      // Store current state in a temp variable:
      startUsers = List<User>.from(widget.users);

      widget.setEditMode(editMode, null);
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
  }

  void _removeUserRows(String id) async {
    await widget.db.delete("users",
        where: "id = ? and pageId = ?", whereArgs: [id, pageId]);
    await widget.db.delete("scores",
        where: "userId = ? AND pageId = ?", whereArgs: [id, pageId]);
  }

  void _resetScores() async {
    widget.resetScores(pageId);
    widget.db
        .rawUpdate('UPDATE scores SET score = 0 WHERE pageId = ?', [pageId]);
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
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Semantics(
                            button: true,
                            child: InputChip(
                                isEnabled:
                                    widget.users.isNotEmpty && !_isEditMode,
                                avatar: const Icon(Icons.refresh),
                                label:
                                    ActionButtonText(text: locale.resetScores),
                                onPressed: () {
                                  ConfirmDialog.show(
                                    context: context,
                                    locale: locale,
                                    title: locale.resetScores,
                                    content: locale.resetScoresPrompt,
                                    confirmText: locale.reset,
                                    onConfirm: _resetScores,
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 4),
                            child: FilterChip(
                              avatar: (widget.config.ranked)
                                  ? const Icon(Icons.star)
                                  : const Icon(Icons.star_border),
                              showCheckmark: false,
                              label: ActionButtonText(
                                  text: locale.ranked,
                                  semantics: locale.semanticRanked),
                              selected: widget.config.ranked,
                              onSelected: _isEditMode ? null : _setRanked,
                            ),
                          ),
                          Semantics(
                            label: widget.config.reversed
                                ? locale.semanticsReverseDesc
                                : locale.semanticsReverseAsc,
                            button: true,
                            child: ActionChip(
                                onPressed: widget.config.ranked && !_isEditMode
                                    ? _reverse
                                    : null,
                                label: Semantics(
                                    excludeSemantics: true,
                                    child: const Text("")),
                                avatar: (() {
                                  if (widget.config.reversed) {
                                    return const Icon(
                                        Icons.keyboard_arrow_down);
                                  } else {
                                    return const Icon(Icons.keyboard_arrow_up);
                                  }
                                })(),
                                labelPadding: EdgeInsets.zero),
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              FilterChip(
                                avatar: (_isEditMode)
                                    ? const Icon(Icons.done)
                                    : const Icon(Icons.edit),
                                showCheckmark: false,
                                label: Semantics(
                                  excludeSemantics: false,
                                  label:
                                      _isEditMode ? locale.done : locale.edit,
                                  child: const Text(""),
                                ),
                                labelPadding: const EdgeInsets.all(0),
                                selected: _isEditMode,
                                onSelected: widget.users.isEmpty
                                    ? null
                                    : _toggleEditMode,
                              ),
                              Visibility(
                                visible: _isDirty,
                                maintainSize: false,
                                child: Positioned(
                                  top: 0, // Adjust positioning for the badge
                                  right: 0, // Adjust positioning for the badge
                                  child: Container(
                                    height: 12, // Adjust badge size
                                    width: 12,
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .transparent, // Badge background color from theme
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceTint,
                                      Icons.emergency,
                                      size: 12, // Icon size inside the badge
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: Semantics(
            label: locale.editableList,
            child: _isEditMode
                ? ReorderableListView(
                    buildDefaultDragHandles: false,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final User user = widget.users.removeAt(oldIndex);
                        widget.users.insert(newIndex, user);
                      });
                    },
                    children: [
                      for (int index = 0; index < widget.users.length; index++)
                        Semantics(
                          key: ValueKey(widget.users[index]),
                          child: Card(
                            elevation: 4,
                            child: UserEditTile(
                              locale: locale,
                              ranked: widget.config.ranked,
                              activeUser: widget.users[index],
                              topScore: widget.topScore,
                              index: index,
                              pageId: pageId,
                              deleteUser: _deleteUser,
                              setScore: (int points) {
                                User activeUser = widget.users[index];
                                widget.updateUser(pageId, index,
                                    activeUser.copyWith(score: points));
                              },
                              renameUser: (User model) =>
                                  widget.updateUser(pageId, index, model),
                            ),
                          ),
                        ),
                    ],
                  )
                : ListView.builder(
                    semanticChildCount: widget.users.length + 1,
                    padding: const EdgeInsets.only(bottom: 96),
                    itemCount: widget.users.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == widget.users.length) {
                        return AddPlayerWidget(
                          locale: locale,
                          pageId: pageId,
                          widget: widget,
                          enabled: !_isEditMode,
                        );
                      } else {
                        User activeUser = widget.users[index];

                        return Semantics(
                          child: Card(
                            elevation: 4,
                            child: UserTile(
                              locale: locale,
                              ranked: widget.config.ranked,
                              activeUser: activeUser,
                              topScore: widget.topScore,
                              index: index,
                              pageId: pageId,
                              deleteUser: _deleteUser,
                              addScore: widget.addScore,
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
