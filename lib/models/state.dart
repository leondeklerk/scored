import 'package:scored/models/config.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/round.dart';
import 'package:scored/models/user.dart';
import 'package:sqflite/sqflite.dart';

class PersistedState {
  Map<int, Map<String, User>> users;
  List<PageModel> pages;
  Map<int, Config?> configs;
  Map<int, Round> rounds;
  Database db;

  PersistedState(
      {required this.users,
      required this.pages,
      required this.configs,
      required this.rounds,
      required this.db});
}
