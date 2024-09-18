// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
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
  String get localeName => 'nl';

  static String m0(userName) => "${userName} - Punten toevoegen";

  static String m1(page) => "Verwijder ${page}";

  static String m2(userName) => "Verwijder ${userName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Voeg toe"),
        "addPage": MessageLookupByLibrary.simpleMessage("Scoreblad toevoegen"),
        "addPlayer": MessageLookupByLibrary.simpleMessage("Speler toevoegen"),
        "addPointsUser": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("Annuleren"),
        "clear": MessageLookupByLibrary.simpleMessage("Maak leeg"),
        "clearButton": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "clearPrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je alle spelers wilt verwijderen?"),
        "clearTitle":
            MessageLookupByLibrary.simpleMessage("Verwijder alle spelers"),
        "confirm": MessageLookupByLibrary.simpleMessage("Oke"),
        "delete": MessageLookupByLibrary.simpleMessage("Verwijder"),
        "deletePage": m1,
        "deletePrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je deze speler wilt verwijderen?"),
        "deleteUser": m2,
        "name": MessageLookupByLibrary.simpleMessage("Naam"),
        "nameError": MessageLookupByLibrary.simpleMessage(
            "Vul de naam van de speler in"),
        "page": MessageLookupByLibrary.simpleMessage("Scoreblad"),
        "pageDeletePrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je dit scoreblad wilt verwijderen?"),
        "player": MessageLookupByLibrary.simpleMessage("Speler"),
        "points": MessageLookupByLibrary.simpleMessage("Punten"),
        "pointsError":
            MessageLookupByLibrary.simpleMessage("Vul het aantal punten int"),
        "ranked": MessageLookupByLibrary.simpleMessage("Ranglijst"),
        "rename": MessageLookupByLibrary.simpleMessage("Hernoem"),
        "renamePage": MessageLookupByLibrary.simpleMessage("Hernoem scoreblad"),
        "reset": MessageLookupByLibrary.simpleMessage("Herstarten"),
        "resetScores": MessageLookupByLibrary.simpleMessage("Herstart"),
        "resetScoresPrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je alle scores op nul wilt zetten?"),
        "score": MessageLookupByLibrary.simpleMessage("Score"),
        "scoreInvalidError":
            MessageLookupByLibrary.simpleMessage("Voer een geldig nummer in"),
        "scoreMissingError":
            MessageLookupByLibrary.simpleMessage("Voer de initiele score in"),
        "semanticAddPoints": MessageLookupByLibrary.simpleMessage(
            "Voeg punten toe aan de speler."),
        "semanticList": MessageLookupByLibrary.simpleMessage("Spelerslijst"),
        "semanticListControls":
            MessageLookupByLibrary.simpleMessage("Spelerslijst knoppen"),
        "semanticName": MessageLookupByLibrary.simpleMessage("Naam:"),
        "semanticRank": MessageLookupByLibrary.simpleMessage("Rang:"),
        "semanticRanked":
            MessageLookupByLibrary.simpleMessage("Toon speler rangen"),
        "semanticRemovePlayer":
            MessageLookupByLibrary.simpleMessage("Verwijder de speler."),
        "semanticScore": MessageLookupByLibrary.simpleMessage("Score: "),
        "semanticsReverseAsc": MessageLookupByLibrary.simpleMessage(
            "Rang volgorde - Hoogste score eerst"),
        "semanticsReverseDesc": MessageLookupByLibrary.simpleMessage(
            "Rang volgorde - Laagste score eerst"),
        "standardPageName": MessageLookupByLibrary.simpleMessage("Scoreblad"),
        "submit": MessageLookupByLibrary.simpleMessage("Oke")
      };
}
