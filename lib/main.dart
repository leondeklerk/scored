import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:scored/home_screen.dart';
import 'package:scored/l10n/app_localizations.dart';
import 'package:scored/models/app_settings_model.dart';
import 'package:scored/models/config.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/score_model.dart';
import 'package:scored/models/user_model.dart';
import 'package:scored/theme_notifier.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'models/config_model.dart';
import 'models/round.dart';
import 'models/round_model.dart';
import 'models/state.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();

  AppSettingsModel appSettings = await AppSettingsModel.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsNotifier(appSettings),
      child: const ScoredApp(),
    ),
  );
}

Future<void> createDb(Database db) async {
  await db.execute(
      "CREATE TABLE IF NOT EXISTS pages(id INTEGER PRIMARY KEY, name TEXT, `order` REAL, currentRound INTEGER);");
  await db.execute(
      'CREATE TABLE IF NOT EXISTS config(ranked INTEGER, reversed INTEGER, pageId INTEGER, FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(pageId));');
  await db.execute(
      'CREATE TABLE IF NOT EXISTS users(id TEXT, name TEXT, `order` INTEGER, pageId INTEGER, FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(id, pageId));');
  await db.execute(
      'CREATE TABLE IF NOT EXISTS scores(userId TEXT, pageId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(userId, pageId));');

  await db.execute(
    'CREATE TABLE IF NOT EXISTS rounds(id TEXT PRIMARY KEY, number INTEGER, pageId INTEGER, userId TEXT, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(number, pageId, userId));',
  );
}

class ScoredApp extends StatelessWidget {
  const ScoredApp({
    super.key,
  });

  Future<PersistedState> getState() async {
    final database = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'scored.db'),
        onCreate: (db, version) async {
      await createDb(db);
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (newVersion >= 2 && newVersion <= 5) {
        await db.execute("DROP TABLE IF EXISTS config");
        await db.execute("DROP TABLE IF EXISTS users");
        await db.execute("DROP TABLE IF EXISTS scores");
        await db.execute("DROP TABLE IF EXISTS pages");
        await createDb(db);
      }

      if (newVersion == 6) {
        await db.execute("ALTER TABLE pages ADD COLUMN `order` REAL;");
        await db.execute("UPDATE pages SET `order` = id;");
      }

      if (newVersion == 7) {}

      if (newVersion == 8) {
        await db.execute("ALTER TABLE users ADD COLUMN `order` INTEGER;");
        // Get all users from the database:
        final List<Map<String, dynamic>> users = await db.query('users');
        for (var i = 0; i < users.length; i++) {
          String id = users[i]['id'];
          // Get the id and split it based on "-":
          List<String> idParts = id.split("-");

          String newId = Uuid().v4();

          // Update the order of the user based on the second part of the id
          await db.update(
              'users', {'order': int.parse(idParts[1]), 'id': newId},
              where: 'id = ?', whereArgs: [id]);

          // Update the user ID in the scores table
          await db.update('scores', {'userId': newId},
              where: 'userId = ?', whereArgs: [id]);
        }
      }

      if (newVersion == 9) {
        await createDb(db);
      }

      if (newVersion == 10) {
        await db.execute("ALTER TABLE pages ADD COLUMN currentRound INTEGER;");
        await db.execute("UPDATE pages SET currentRound = 1;");
      }
    }, version: 10);

    final List<Map<String, dynamic>> configs = await database.query('config');
    final List<Map<String, dynamic>> users =
        await database.query('users', orderBy: "`order` ASC");
    final List<Map<String, dynamic>> scores = await database.query('scores');
    final List<Map<String, dynamic>> pages =
        await database.query('pages', orderBy: "`order` ASC");
    final List<Map<String, dynamic>> rounds =
        await database.query('rounds', orderBy: "`number` ASC");

    List<ConfigModel> configList = List.generate(configs.length, (i) {
      return ConfigModel(
        ranked: configs[i]['ranked'] as int,
        reversed: configs[i]['reversed'] as int,
        pageId: configs[i]['pageId'] as int,
      );
    });

    List<ScoreModel> scoresList = List.generate(scores.length, (i) {
      return ScoreModel(
        userId: scores[i]['userId'] as String,
        pageId: scores[i]['pageId'] as int,
        score: scores[i]['score'] as int,
      );
    });

    List<UserModel> usersList = List.generate(users.length, (i) {
      return UserModel(
        id: users[i]['id'] as String,
        name: users[i]['name'] as String,
        pageId: users[i]['pageId'] as int,
        order: users[i]['order'] as int,
      );
    });

    List<PageModel> pagesList = List.generate(pages.length, (i) {
      return PageModel(
        id: pages[i]['id'] as int,
        name: pages[i]['name'] as String,
        order: pages[i]['order'] as double,
        currentRound: pages[i]['currentRound'] as int,
      );
    });

    List<RoundModel> roundsList = List.generate(rounds.length, (i) {
      return RoundModel(
        id: rounds[i]['id'] as String,
        number: rounds[i]['number'] as int,
        pageId: rounds[i]['pageId'] as int,
        userId: rounds[i]['userId'] as String,
      );
    });

    PersistedState state = PersistedState(
        users: {}, pages: [], configs: {}, rounds: {}, db: database);

    for (var i = 0; i < configList.length; i++) {
      ConfigModel config = configList[i];
      state.configs[config.pageId] = Config(
          ranked: config.ranked == 1 ? true : false,
          reversed: config.reversed == 1 ? true : false,
          pageId: config.pageId);
    }

    state.pages = pagesList;

    for (var i = 0; i < pagesList.length; i++) {
      state.users[pagesList[i].id] = {};
      // Make sure every page has a round (default is round 1 no users)
      state.rounds[pagesList[i].id] =
          Round(id: Uuid().v4(), number: pagesList[i].currentRound, scores: {});
    }

    for (var i = 0; i < usersList.length; i++) {
      var userEntry = usersList[i];
      var user =
          User(name: userEntry.name, order: userEntry.order, id: userEntry.id);
      if (state.users[userEntry.pageId] == null) {
        state.users[userEntry.pageId] = {};
      }

      state.users[userEntry.pageId]![user.id] = user;
    }

    for (var i = 0; i < scoresList.length; i++) {
      var scoreEntry = scoresList[i];
      state.users[scoreEntry.pageId]![scoreEntry.userId]!.score =
          scoreEntry.score;
    }

    for (var i = 0; i < roundsList.length; i++) {
      var roundEntry = roundsList[i];
      var key = roundEntry.pageId;

      var currentRound = state.rounds[key]!;
      // If it is a newer round we need to overwrite the current round (inefficient)
      if (roundEntry.number > currentRound.number) {
        state.rounds[roundEntry.pageId] =
            Round(id: roundEntry.id, number: roundEntry.number, scores: {
          roundEntry.userId: 0,
          // Note: currently scores are not yet parts of rounds
        });
      } else if (roundEntry.number == currentRound.number) {
        // If it is the same round we need to add the userId to the current round
        currentRound.scores[roundEntry.userId] = 0;
        currentRound.id = roundEntry.id;
      }
    }

    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
            title: 'Scored',
            theme: notifier.lightTheme,
            darkTheme: notifier.darkTheme,
            themeMode: notifier.themeMode,
            locale: notifier.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: FutureBuilder(
                future: getState(),
                builder: (context, AsyncSnapshot<PersistedState> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return HomeScreen(
                      db: snapshot.data!.db,
                      state: snapshot.data,
                    );
                  }
                  return Scaffold(
                      body: Center(
                    child: Transform.scale(
                        scale: 3,
                        child: const CircularProgressIndicator(
                          strokeWidth: 1,
                        )),
                  ));
                }));
      },
    );
  }
}
