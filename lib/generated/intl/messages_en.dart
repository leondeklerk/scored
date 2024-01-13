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

  static String m1(page) => "Delete ${page}";

  static String m2(userName) => "Delete ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addPage": MessageLookupByLibrary.simpleMessage("Add page"),
        "addPlayer": MessageLookupByLibrary.simpleMessage("Add player"),
        "addPointsUser": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearButton": MessageLookupByLibrary.simpleMessage("Clear"),
        "clearPrompt": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to remove all players?"),
        "clearTitle": MessageLookupByLibrary.simpleMessage("Clear all player"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deletePage": m1,
        "deletePrompt": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this player?"),
        "deleteUser": m2,
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "nameError": MessageLookupByLibrary.simpleMessage("Enter a name"),
        "page": MessageLookupByLibrary.simpleMessage("Page"),
        "pageDeletePrompt": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this page?"),
        "player": MessageLookupByLibrary.simpleMessage("Player"),
        "points": MessageLookupByLibrary.simpleMessage("Points"),
        "pointsError":
            MessageLookupByLibrary.simpleMessage("Enter the number of points"),
        "ranked": MessageLookupByLibrary.simpleMessage("Ranked"),
        "rename": MessageLookupByLibrary.simpleMessage("Rename"),
        "renamePage": MessageLookupByLibrary.simpleMessage("Rename page"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "resetScores": MessageLookupByLibrary.simpleMessage("Reset scores"),
        "resetScoresPrompt": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to reset all scores?"),
        "score": MessageLookupByLibrary.simpleMessage("Score"),
        "scoreInvalidError":
            MessageLookupByLibrary.simpleMessage("Enter a valid number"),
        "scoreMissingError":
            MessageLookupByLibrary.simpleMessage("Enter the initial score"),
        "semanticAddPoints":
            MessageLookupByLibrary.simpleMessage("Add points to player."),
        "semanticList": MessageLookupByLibrary.simpleMessage("List of players"),
        "semanticListControls":
            MessageLookupByLibrary.simpleMessage("Player list controls"),
        "semanticName": MessageLookupByLibrary.simpleMessage("Name:"),
        "semanticRank": MessageLookupByLibrary.simpleMessage("Rank:"),
        "semanticRanked":
            MessageLookupByLibrary.simpleMessage("Show player ranks"),
        "semanticRemovePlayer":
            MessageLookupByLibrary.simpleMessage("Remove player."),
        "semanticScore": MessageLookupByLibrary.simpleMessage("Score"),
        "semanticsReverseAsc": MessageLookupByLibrary.simpleMessage(
            "Rank order - Highest score first"),
        "semanticsReverseDesc": MessageLookupByLibrary.simpleMessage(
            "Rang order - Lowest score first"),
        "standardPageName": MessageLookupByLibrary.simpleMessage("Default"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit")
      };
}
