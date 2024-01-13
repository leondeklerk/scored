// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clearButton {
    return Intl.message(
      'Clear',
      name: 'clearButton',
      desc: '',
      args: [],
    );
  }

  /// `Clear all player`
  String get clearTitle {
    return Intl.message(
      'Clear all player',
      name: 'clearTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove all players?`
  String get clearPrompt {
    return Intl.message(
      'Are you sure you want to remove all players?',
      name: 'clearPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Reset scores`
  String get resetScores {
    return Intl.message(
      'Reset scores',
      name: 'resetScores',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset all scores?`
  String get resetScoresPrompt {
    return Intl.message(
      'Are you sure you want to reset all scores?',
      name: 'resetScoresPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Ranked`
  String get ranked {
    return Intl.message(
      'Ranked',
      name: 'ranked',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this player?`
  String get deletePrompt {
    return Intl.message(
      'Are you sure you want to delete this player?',
      name: 'deletePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Add player`
  String get addPlayer {
    return Intl.message(
      'Add player',
      name: 'addPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Enter the number of points`
  String get pointsError {
    return Intl.message(
      'Enter the number of points',
      name: 'pointsError',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name`
  String get nameError {
    return Intl.message(
      'Enter a name',
      name: 'nameError',
      desc: '',
      args: [],
    );
  }

  /// `Player`
  String get player {
    return Intl.message(
      'Player',
      name: 'player',
      desc: '',
      args: [],
    );
  }

  /// `Enter the initial score`
  String get scoreMissingError {
    return Intl.message(
      'Enter the initial score',
      name: 'scoreMissingError',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid number`
  String get scoreInvalidError {
    return Intl.message(
      'Enter a valid number',
      name: 'scoreInvalidError',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get score {
    return Intl.message(
      'Score',
      name: 'score',
      desc: '',
      args: [],
    );
  }

  /// `Delete {userName}`
  String deleteUser(String userName) {
    return Intl.message(
      'Delete $userName',
      name: 'deleteUser',
      desc: 'Delete with username template',
      args: [userName],
    );
  }

  /// `{userName} - Add points`
  String addPointsUser(String userName) {
    return Intl.message(
      '$userName - Add points',
      name: 'addPointsUser',
      desc: 'Add points with included username',
      args: [userName],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Rank:`
  String get semanticRank {
    return Intl.message(
      'Rank:',
      name: 'semanticRank',
      desc: '',
      args: [],
    );
  }

  /// `Name:`
  String get semanticName {
    return Intl.message(
      'Name:',
      name: 'semanticName',
      desc: '',
      args: [],
    );
  }

  /// `Score`
  String get semanticScore {
    return Intl.message(
      'Score',
      name: 'semanticScore',
      desc: '',
      args: [],
    );
  }

  /// `List of players`
  String get semanticList {
    return Intl.message(
      'List of players',
      name: 'semanticList',
      desc: '',
      args: [],
    );
  }

  /// `Show player ranks`
  String get semanticRanked {
    return Intl.message(
      'Show player ranks',
      name: 'semanticRanked',
      desc: '',
      args: [],
    );
  }

  /// `Player list controls`
  String get semanticListControls {
    return Intl.message(
      'Player list controls',
      name: 'semanticListControls',
      desc: '',
      args: [],
    );
  }

  /// `Add points to player.`
  String get semanticAddPoints {
    return Intl.message(
      'Add points to player.',
      name: 'semanticAddPoints',
      desc: '',
      args: [],
    );
  }

  /// `Remove player.`
  String get semanticRemovePlayer {
    return Intl.message(
      'Remove player.',
      name: 'semanticRemovePlayer',
      desc: '',
      args: [],
    );
  }

  /// `Rank order - Highest score first`
  String get semanticsReverseAsc {
    return Intl.message(
      'Rank order - Highest score first',
      name: 'semanticsReverseAsc',
      desc: '',
      args: [],
    );
  }

  /// `Rang order - Lowest score first`
  String get semanticsReverseDesc {
    return Intl.message(
      'Rang order - Lowest score first',
      name: 'semanticsReverseDesc',
      desc: '',
      args: [],
    );
  }

  /// `Default`
  String get standardPageName {
    return Intl.message(
      'Default',
      name: 'standardPageName',
      desc: '',
      args: [],
    );
  }

  /// `Rename page`
  String get renamePage {
    return Intl.message(
      'Rename page',
      name: 'renamePage',
      desc: '',
      args: [],
    );
  }

  /// `Delete {page}`
  String deletePage(String page) {
    return Intl.message(
      'Delete $page',
      name: 'deletePage',
      desc: 'Delete with page name template',
      args: [page],
    );
  }

  /// `Are you sure you want to delete this page?`
  String get pageDeletePrompt {
    return Intl.message(
      'Are you sure you want to delete this page?',
      name: 'pageDeletePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Page`
  String get page {
    return Intl.message(
      'Page',
      name: 'page',
      desc: '',
      args: [],
    );
  }

  /// `Add page`
  String get addPage {
    return Intl.message(
      'Add page',
      name: 'addPage',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get rename {
    return Intl.message(
      'Rename',
      name: 'rename',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'nl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
