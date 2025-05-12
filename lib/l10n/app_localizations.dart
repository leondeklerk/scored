import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl')
  ];

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearButton;

  /// No description provided for @clearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all players'**
  String get clearTitle;

  /// No description provided for @clearPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove all players?'**
  String get clearPrompt;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get confirm;

  /// No description provided for @resetScores.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetScores;

  /// No description provided for @resetScoresPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all scores?'**
  String get resetScoresPrompt;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @ranked.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get ranked;

  /// No description provided for @deletePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this player?'**
  String get deletePrompt;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get delete;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get addPlayer;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @pointsError.
  ///
  /// In en, this message translates to:
  /// **'Enter the number of points'**
  String get pointsError;

  /// Points length error template
  ///
  /// In en, this message translates to:
  /// **'Points can\'t be larger than {size} digits'**
  String pointsLengthError(int size);

  /// No description provided for @nameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get nameError;

  /// Name length error template
  ///
  /// In en, this message translates to:
  /// **'Name can\'t be longer than {length} characters'**
  String nameLengthError(int length);

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @scoreMissingError.
  ///
  /// In en, this message translates to:
  /// **'Enter the initial score'**
  String get scoreMissingError;

  /// No description provided for @scoreInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get scoreInvalidError;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Remove with username template
  ///
  /// In en, this message translates to:
  /// **'Remove {userName}'**
  String deleteUser(String userName);

  /// Add points with included username
  ///
  /// In en, this message translates to:
  /// **'{userName} - Add points'**
  String addPointsUser(String userName);

  /// Set points with for user
  ///
  /// In en, this message translates to:
  /// **'{userName} - Set points'**
  String setPointsUser(String userName);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @semanticRank.
  ///
  /// In en, this message translates to:
  /// **'Rank:'**
  String get semanticRank;

  /// No description provided for @semanticName.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get semanticName;

  /// No description provided for @semanticScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get semanticScore;

  /// No description provided for @semanticList.
  ///
  /// In en, this message translates to:
  /// **'List of players'**
  String get semanticList;

  /// No description provided for @semanticRanked.
  ///
  /// In en, this message translates to:
  /// **'Show player ranks'**
  String get semanticRanked;

  /// No description provided for @semanticListControls.
  ///
  /// In en, this message translates to:
  /// **'Player list controls'**
  String get semanticListControls;

  /// No description provided for @semanticAddPoints.
  ///
  /// In en, this message translates to:
  /// **'Add points to player.'**
  String get semanticAddPoints;

  /// No description provided for @semanticRemovePlayer.
  ///
  /// In en, this message translates to:
  /// **'Remove player.'**
  String get semanticRemovePlayer;

  /// No description provided for @semanticsReverseAsc.
  ///
  /// In en, this message translates to:
  /// **'Rank order - Highest score first'**
  String get semanticsReverseAsc;

  /// No description provided for @semanticsReverseDesc.
  ///
  /// In en, this message translates to:
  /// **'Rang order - Lowest score first'**
  String get semanticsReverseDesc;

  /// No description provided for @standardPageName.
  ///
  /// In en, this message translates to:
  /// **'Score sheet'**
  String get standardPageName;

  /// No description provided for @renamePage.
  ///
  /// In en, this message translates to:
  /// **'Rename sheet'**
  String get renamePage;

  /// Rename with username template
  ///
  /// In en, this message translates to:
  /// **'Rename {userName}'**
  String renameUser(String userName);

  /// Remove with page name template
  ///
  /// In en, this message translates to:
  /// **'Remove {page}'**
  String deletePage(String page);

  /// No description provided for @pageDeletePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this score sheet?'**
  String get pageDeletePrompt;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Score sheet'**
  String get page;

  /// No description provided for @addPage.
  ///
  /// In en, this message translates to:
  /// **'Add sheet'**
  String get addPage;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get selectColor;

  /// No description provided for @selectColorShade.
  ///
  /// In en, this message translates to:
  /// **'Shade'**
  String get selectColorShade;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectColorTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a color'**
  String get selectColorTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingBaseColor.
  ///
  /// In en, this message translates to:
  /// **'Base color'**
  String get settingBaseColor;

  /// No description provided for @settingsCustomColorMode.
  ///
  /// In en, this message translates to:
  /// **'Use custom colors'**
  String get settingsCustomColorMode;

  /// No description provided for @settingThemeModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get settingThemeModeTitle;

  /// No description provided for @settingThemeModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get settingThemeModeAuto;

  /// No description provided for @settingThemeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingThemeModeLight;

  /// No description provided for @settingThemeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingThemeModeDark;

  /// No description provided for @settingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguageTitle;

  /// No description provided for @settingGroupThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingGroupThemeTitle;

  /// No description provided for @settingGroupGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingGroupGeneralTitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChangesTitle;

  /// No description provided for @saveChangesContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save the changes?'**
  String get saveChangesContent;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @editableList.
  ///
  /// In en, this message translates to:
  /// **'Editable player list'**
  String get editableList;

  /// No description provided for @semanticReorder.
  ///
  /// In en, this message translates to:
  /// **'Reorder handle'**
  String get semanticReorder;

  /// No description provided for @semanticEditScore.
  ///
  /// In en, this message translates to:
  /// **'Edit score'**
  String get semanticEditScore;

  /// No description provided for @semanticEditName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get semanticEditName;

  /// No description provided for @nextRound.
  ///
  /// In en, this message translates to:
  /// **'Next round'**
  String get nextRound;

  /// No description provided for @nextRoundPrompt.
  ///
  /// In en, this message translates to:
  /// **'Not all players have scores for this round. Are you sure you want to proceed to the next round?'**
  String get nextRoundPrompt;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @settingShowNextRoundConfirmDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Next round confirmation'**
  String get settingShowNextRoundConfirmDialogTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
