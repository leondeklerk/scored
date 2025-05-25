// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get add => 'Add';

  @override
  String get set => 'Set';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get clearButton => 'Clear';

  @override
  String get clearTitle => 'Clear all players';

  @override
  String get clearPrompt => 'Are you sure you want to remove all players?';

  @override
  String get confirm => 'Ok';

  @override
  String get resetScores => 'Reset';

  @override
  String get resetScoresPrompt => 'Are you sure you want to reset all scores?';

  @override
  String get reset => 'Reset';

  @override
  String get ranked => 'Rank';

  @override
  String get deletePrompt => 'Are you sure you want to remove this player?';

  @override
  String get delete => 'Remove';

  @override
  String get addPlayer => 'Add player';

  @override
  String get points => 'Points';

  @override
  String get pointsError => 'Enter the number of points';

  @override
  String pointsLengthError(int size) {
    return 'Points can\'t be larger than $size digits';
  }

  @override
  String get nameError => 'Enter a name';

  @override
  String nameLengthError(int length) {
    return 'Name can\'t be longer than $length characters';
  }

  @override
  String get player => 'Player';

  @override
  String get scoreMissingError => 'Enter the initial score';

  @override
  String get scoreInvalidError => 'Enter a valid number';

  @override
  String get score => 'Score';

  @override
  String deleteUser(String userName) {
    return 'Remove $userName';
  }

  @override
  String addPointsUser(String userName) {
    return '$userName - Add points';
  }

  @override
  String setPointsUser(String userName) {
    return '$userName - Set points';
  }

  @override
  String get name => 'Name';

  @override
  String get semanticRank => 'Rank:';

  @override
  String get semanticName => 'Name:';

  @override
  String get semanticScore => 'Score';

  @override
  String get semanticList => 'List of players';

  @override
  String get semanticRanked => 'Show player ranks';

  @override
  String get semanticListControls => 'Player list controls';

  @override
  String get semanticAddPoints => 'Add points to player.';

  @override
  String get semanticRemovePlayer => 'Remove player.';

  @override
  String get semanticsReverseAsc => 'Rank order - Highest score first';

  @override
  String get semanticsReverseDesc => 'Rang order - Lowest score first';

  @override
  String get standardPageName => 'Score sheet';

  @override
  String get renamePage => 'Rename sheet';

  @override
  String renameUser(String userName) {
    return 'Rename $userName';
  }

  @override
  String deletePage(String page) {
    return 'Remove $page';
  }

  @override
  String get pageDeletePrompt =>
      'Are you sure you want to remove this score sheet?';

  @override
  String get page => 'Score sheet';

  @override
  String get addPage => 'Add sheet';

  @override
  String get rename => 'Rename';

  @override
  String get selectColor => 'Color';

  @override
  String get selectColorShade => 'Shade';

  @override
  String get select => 'Select';

  @override
  String get selectColorTitle => 'Select a color';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingBaseColor => 'Base color';

  @override
  String get settingsCustomColorMode => 'Use custom colors';

  @override
  String get settingThemeModeTitle => 'Theme mode';

  @override
  String get settingThemeModeAuto => 'Auto';

  @override
  String get settingThemeModeLight => 'Light';

  @override
  String get settingThemeModeDark => 'Dark';

  @override
  String get settingLanguageTitle => 'Language';

  @override
  String get settingGroupThemeTitle => 'Theme';

  @override
  String get settingGroupGeneralTitle => 'General';

  @override
  String get done => 'Done';

  @override
  String get edit => 'Edit';

  @override
  String get saveChangesTitle => 'Save changes';

  @override
  String get saveChangesContent => 'Do you want to save the changes?';

  @override
  String get save => 'Save';

  @override
  String get discard => 'Discard';

  @override
  String get editableList => 'Editable player list';

  @override
  String get semanticReorder => 'Reorder handle';

  @override
  String get semanticEditScore => 'Edit score';

  @override
  String get semanticEditName => 'Edit name';

  @override
  String get nextRound => 'Next round';

  @override
  String get nextRoundPrompt =>
      'Not all players have scores for this round. Are you sure you want to proceed to the next round?';

  @override
  String get next => 'Next';

  @override
  String get settingShowNextRoundConfirmDialogTitle =>
      'Next round confirmation';

  @override
  String get settingUseRoundsTitle => 'Enable rounds';
}
