// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get add => 'Voeg toe';

  @override
  String get set => 'Instellen';

  @override
  String get submit => 'Oke';

  @override
  String get cancel => 'Annuleren';

  @override
  String get clear => 'Wis';

  @override
  String get clearButton => 'Verwijderen';

  @override
  String get clearTitle => 'Verwijder alle spelers';

  @override
  String get clearPrompt =>
      'Weet je zeker dat je alle spelers wilt verwijderen?';

  @override
  String get confirm => 'Oke';

  @override
  String get resetScores => 'Herstart';

  @override
  String get resetScoresPrompt =>
      'Weet je zeker dat je alle scores op nul wilt zetten?';

  @override
  String get reset => 'Herstart';

  @override
  String get ranked => 'Stand';

  @override
  String get deletePrompt =>
      'Weet je zeker dat je deze speler wilt verwijderen?';

  @override
  String get delete => 'Verwijder';

  @override
  String get addPlayer => 'Speler toevoegen';

  @override
  String get points => 'Punten';

  @override
  String get pointsError => 'Vul het aantal punten int';

  @override
  String pointsLengthError(int size) {
    return 'Punten mogen maximaal $size cijfers lang zijn';
  }

  @override
  String get nameError => 'Vul de naam van de speler in';

  @override
  String nameLengthError(int length) {
    return 'De naam mag niet langer zijn dan $length karakters';
  }

  @override
  String get player => 'Speler';

  @override
  String get scoreMissingError => 'Voer de initiele score in';

  @override
  String get scoreInvalidError => 'Voer een geldig nummer in';

  @override
  String get score => 'Score';

  @override
  String deleteUser(String userName) {
    return 'Verwijder $userName';
  }

  @override
  String addPointsUser(String userName) {
    return '$userName - Punten toevoegen';
  }

  @override
  String setPointsUser(String userName) {
    return '$userName - Punten instellen';
  }

  @override
  String get name => 'Naam';

  @override
  String get semanticRank => 'Rang:';

  @override
  String get semanticName => 'Naam:';

  @override
  String get semanticScore => 'Score: ';

  @override
  String get semanticList => 'Spelerslijst';

  @override
  String get semanticRanked => 'Toon speler rangen';

  @override
  String get semanticListControls => 'Spelerslijst knoppen';

  @override
  String get semanticAddPoints => 'Voeg punten toe aan de speler.';

  @override
  String get semanticRemovePlayer => 'Verwijder de speler.';

  @override
  String get semanticsReverseAsc => 'Rang volgorde - Hoogste score eerst';

  @override
  String get semanticsReverseDesc => 'Rang volgorde - Laagste score eerst';

  @override
  String get standardPageName => 'Scoreblad';

  @override
  String get renamePage => 'Hernoem scoreblad';

  @override
  String renameUser(String userName) {
    return 'Hernoem $userName';
  }

  @override
  String deletePage(String page) {
    return 'Verwijder $page';
  }

  @override
  String get pageDeletePrompt =>
      'Weet je zeker dat je dit scoreblad wilt verwijderen?';

  @override
  String get page => 'Scoreblad';

  @override
  String get addPage => 'Blad toevoegen';

  @override
  String get rename => 'Hernoem';

  @override
  String get selectColor => 'Kleur';

  @override
  String get selectColorShade => 'Tint';

  @override
  String get select => 'Selecteer';

  @override
  String get selectColorTitle => 'Selecteer een kleur';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingBaseColor => 'Basis kleur';

  @override
  String get settingsCustomColorMode => 'Gebruik custom kleuren';

  @override
  String get settingThemeModeTitle => 'Thema modus';

  @override
  String get settingThemeModeAuto => 'Auto';

  @override
  String get settingThemeModeLight => 'Licht';

  @override
  String get settingThemeModeDark => 'Donker';

  @override
  String get settingLanguageTitle => 'Taal';

  @override
  String get settingGroupThemeTitle => 'Thema';

  @override
  String get settingGroupGeneralTitle => 'Algemeen';

  @override
  String get done => 'Klaar';

  @override
  String get edit => 'Bewerk';

  @override
  String get saveChangesTitle => 'Wijzigingen opslaan';

  @override
  String get saveChangesContent => 'Wil je de wijzigingen opslaan?';

  @override
  String get save => 'Opslaan';

  @override
  String get discard => 'Niet opslaan';

  @override
  String get editableList => 'Bewerkbare spelerslijst';

  @override
  String get semanticReorder => 'Herorden handvat';

  @override
  String get semanticEditScore => 'Bewerk score';

  @override
  String get semanticEditName => 'Bewerk naam';

  @override
  String get nextRound => 'Volgende ronde';

  @override
  String get nextRoundPrompt =>
      'Niet bij elke speler zijn punten toegevoegd, weet je zeker dat je de volgende ronde wilt starten?';

  @override
  String get next => 'Volgende';

  @override
  String get settingShowNextRoundConfirmDialogTitle =>
      'Bevestiging volgende ronde';

  @override
  String get settingUseRoundsTitle => 'Rondes inschakelen';
}
