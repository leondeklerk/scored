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

  static String m1(userName) => "Verwijder ${userName}";

  static String m2(userName) =>
      "Popup om het verwijderen van speler ${userName} te bevestigen";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Voeg toe"),
        "addPlayer": MessageLookupByLibrary.simpleMessage("Speler toevoegen"),
        "addPointsUser": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("Annuleren"),
        "clear": MessageLookupByLibrary.simpleMessage("Maak leeg"),
        "clearButton": MessageLookupByLibrary.simpleMessage("Verwijderen"),
        "clearPrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je alle spelers wilt verwijderen?"),
        "clearTitle":
            MessageLookupByLibrary.simpleMessage("Verwijder alle spelers"),
        "delete": MessageLookupByLibrary.simpleMessage("Verwijder"),
        "deletePrompt": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je deze speler wilt verwijderen?"),
        "deleteUser": m1,
        "name": MessageLookupByLibrary.simpleMessage("Naam"),
        "nameError": MessageLookupByLibrary.simpleMessage(
            "Vul de naam van de speler in"),
        "player": MessageLookupByLibrary.simpleMessage("Speler"),
        "points": MessageLookupByLibrary.simpleMessage("Punten"),
        "pointsError":
            MessageLookupByLibrary.simpleMessage("Vul het aantal punten int"),
        "ranked": MessageLookupByLibrary.simpleMessage("Ranglijst"),
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
            "Popup om punten aan een speler toe te voegen "),
        "semanticAddUser": MessageLookupByLibrary.simpleMessage(
            "Popup om een nieuwe speler toe te voegen"),
        "semanticClearDialog": MessageLookupByLibrary.simpleMessage(
            "Popup om het verwijderen van alle spelers te bevestigen"),
        "semanticDeleteUserDialog": m2,
        "semanticName":
            MessageLookupByLibrary.simpleMessage("Naam van de speler"),
        "semanticRank":
            MessageLookupByLibrary.simpleMessage("Rang van de speler"),
        "semanticRankIcon": MessageLookupByLibrary.simpleMessage(
            "Ster om aan te geven dat de speler om de eerste plaats staat"),
        "semanticResetDialog": MessageLookupByLibrary.simpleMessage(
            "Popup om het op nul zetten van alle scores te bevestigen"),
        "semanticScore":
            MessageLookupByLibrary.simpleMessage("Score van de speler"),
        "submit": MessageLookupByLibrary.simpleMessage("Oke")
      };
}
