import 'package:flutter/material.dart';
import 'package:scored/home_screen.dart';
import 'package:scored/models/config.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/score_model.dart';
import 'package:scored/models/user_model.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/config_model.dart';
import 'models/state.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();

  final database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'scored.db'),
      onCreate: (db, version) async {
    await createDb(db);
  }, onUpgrade: (db, oldVersion, newVersion) async {
    if (newVersion == 2 || newVersion == 3 || newVersion == 4 || newVersion == 5) {
      await db.execute("DROP TABLE IF EXISTS config");
      await db.execute("DROP TABLE IF EXISTS users");
      await db.execute("DROP TABLE IF EXISTS scores");
      await db.execute("DROP TABLE IF EXISTS pages");
      await createDb(db);
    }
  }, version: 5);

  runApp(ScoredApp(database: database));
}

Future<void> createDb(Database db) async {

  await db.execute("CREATE TABLE IF NOT EXISTS pages(id INTEGER PRIMARY KEY, name TEXT);");
  await db.execute(
      'CREATE TABLE IF NOT EXISTS config(ranked INTEGER, reversed INTEGER, pageId INTEGER, FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(pageId));');
  await db.execute(
      'CREATE TABLE IF NOT EXISTS users(id TEXT, name TEXT, pageId INTEGER, FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(id, pageId));');
  await db.execute(
      'CREATE TABLE IF NOT EXISTS scores(userId TEXT, pageId INTEGER, score INTEGER, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(pageId) REFERENCES pages(id), UNIQUE(userId, pageId));');
}

class ScoredApp extends StatelessWidget {
  final Database database;

  const ScoredApp({
    required this.database,
    super.key,
  });

  Future<PersistedState> getState() async {
    final List<Map<String, dynamic>> configs = await database.query('config');
    final List<Map<String, dynamic>> users =
        await database.query('users', orderBy: "name ASC");
    final List<Map<String, dynamic>> scores = await database.query('scores');
    final List<Map<String, dynamic>> pages =
        await database.query('pages', orderBy: "id ASC");

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
      );
    });

    List<PageModel> pagesList = List.generate(pages.length, (i) {
      return PageModel(
        id: pages[i]['id'] as int,
        name: pages[i]['name'] as String,
      );
    });

    PersistedState state = PersistedState(users: {}, pages: [], configs: {});


    for (var i = 0; i < configList.length; i++) {
      ConfigModel config = configList[i];
      state.configs[config.pageId] = Config(ranked: config.ranked == 1 ? true : false, reversed: config.reversed == 1 ? true : false, pageId: config.pageId);
    }

    state.pages = pagesList;

    for (var i = 0; i < pagesList.length; i++) {
      state.users[i] = {};
    }

    for (var i = 0; i < usersList.length; i++) {
      var userEntry = usersList[i];
      var user = User(name: userEntry.name);
      user.id = userEntry.id;
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

    return state;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scored',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(
                  child: Transform.scale(
                      scale: 3,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1,
                      )),
                ));
              } else {
                return HomeScreen(db: database, state: snapshot.data);
              }
            }));
  }
}
