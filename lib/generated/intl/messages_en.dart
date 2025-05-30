// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(userName) => "${userName} - Add points";

  static String m1(page) => "Remove ${page}";

  static String m2(userName) => "Remove ${userName}";

  static String m3(length) => "Name can\'t be longer than ${length} characters";

  static String m4(size) => "Points can\'t be larger than ${size} digits";

  static String m5(userName) => "Rename ${userName}";

  static String m6(userName) => "${userName} - Set points";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addPage": MessageLookupByLibrary.simpleMessage("Add sheet"),
    "addPlayer": MessageLookupByLibrary.simpleMessage("Add player"),
    "addPointsUser": m0,
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearButton": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearPrompt": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove all players?",
    ),
    "clearTitle": MessageLookupByLibrary.simpleMessage("Clear all players"),
    "confirm": MessageLookupByLibrary.simpleMessage("Ok"),
    "delete": MessageLookupByLibrary.simpleMessage("Remove"),
    "deletePage": m1,
    "deletePrompt": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove this player?",
    ),
    "deleteUser": m2,
    "discard": MessageLookupByLibrary.simpleMessage("Discard"),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editableList": MessageLookupByLibrary.simpleMessage(
      "Editable player list",
    ),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameError": MessageLookupByLibrary.simpleMessage("Enter a name"),
    "nameLengthError": m3,
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "nextRound": MessageLookupByLibrary.simpleMessage("Next round"),
    "nextRoundPrompt": MessageLookupByLibrary.simpleMessage(
      "Not all players have scores for this round. Are you sure you want to proceed to the next round?",
    ),
    "page": MessageLookupByLibrary.simpleMessage("Score sheet"),
    "pageDeletePrompt": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to remove this score sheet?",
    ),
    "player": MessageLookupByLibrary.simpleMessage("Player"),
    "points": MessageLookupByLibrary.simpleMessage("Points"),
    "pointsError": MessageLookupByLibrary.simpleMessage(
      "Enter the number of points",
    ),
    "pointsLengthError": m4,
    "ranked": MessageLookupByLibrary.simpleMessage("Rank"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "renamePage": MessageLookupByLibrary.simpleMessage("Rename sheet"),
    "renameUser": m5,
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetScores": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetScoresPrompt": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to reset all scores?",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChangesContent": MessageLookupByLibrary.simpleMessage(
      "Do you want to save the changes?",
    ),
    "saveChangesTitle": MessageLookupByLibrary.simpleMessage("Save changes"),
    "score": MessageLookupByLibrary.simpleMessage("Score"),
    "scoreInvalidError": MessageLookupByLibrary.simpleMessage(
      "Enter a valid number",
    ),
    "scoreMissingError": MessageLookupByLibrary.simpleMessage(
      "Enter the initial score",
    ),
    "select": MessageLookupByLibrary.simpleMessage("Select"),
    "selectColor": MessageLookupByLibrary.simpleMessage("Color"),
    "selectColorShade": MessageLookupByLibrary.simpleMessage("Shade"),
    "selectColorTitle": MessageLookupByLibrary.simpleMessage("Select a color"),
    "semanticAddPoints": MessageLookupByLibrary.simpleMessage(
      "Add points to player.",
    ),
    "semanticEditName": MessageLookupByLibrary.simpleMessage("Edit name"),
    "semanticEditScore": MessageLookupByLibrary.simpleMessage("Edit score"),
    "semanticList": MessageLookupByLibrary.simpleMessage("List of players"),
    "semanticListControls": MessageLookupByLibrary.simpleMessage(
      "Player list controls",
    ),
    "semanticName": MessageLookupByLibrary.simpleMessage("Name:"),
    "semanticRank": MessageLookupByLibrary.simpleMessage("Rank:"),
    "semanticRanked": MessageLookupByLibrary.simpleMessage("Show player ranks"),
    "semanticRemovePlayer": MessageLookupByLibrary.simpleMessage(
      "Remove player.",
    ),
    "semanticReorder": MessageLookupByLibrary.simpleMessage("Reorder handle"),
    "semanticScore": MessageLookupByLibrary.simpleMessage("Score"),
    "semanticsReverseAsc": MessageLookupByLibrary.simpleMessage(
      "Rank order - Highest score first",
    ),
    "semanticsReverseDesc": MessageLookupByLibrary.simpleMessage(
      "Rang order - Lowest score first",
    ),
    "set": MessageLookupByLibrary.simpleMessage("Set"),
    "setPointsUser": m6,
    "settingBaseColor": MessageLookupByLibrary.simpleMessage("Base color"),
    "settingGroupGeneralTitle": MessageLookupByLibrary.simpleMessage("General"),
    "settingGroupThemeTitle": MessageLookupByLibrary.simpleMessage("Theme"),
    "settingLanguageTitle": MessageLookupByLibrary.simpleMessage("Language"),
    "settingShowNextRoundConfirmDialogTitle":
        MessageLookupByLibrary.simpleMessage("Next round confirmation"),
    "settingThemeModeAuto": MessageLookupByLibrary.simpleMessage("Auto"),
    "settingThemeModeDark": MessageLookupByLibrary.simpleMessage("Dark"),
    "settingThemeModeLight": MessageLookupByLibrary.simpleMessage("Light"),
    "settingThemeModeTitle": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "settingUseRoundsTitle": MessageLookupByLibrary.simpleMessage(
      "Enable rounds",
    ),
    "settingsCustomColorMode": MessageLookupByLibrary.simpleMessage(
      "Use custom colors",
    ),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "standardPageName": MessageLookupByLibrary.simpleMessage("Score sheet"),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
  };
}
