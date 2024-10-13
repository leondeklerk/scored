import 'package:scored/models/config.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/user.dart';
import 'package:sqflite/sqflite.dart';

class PersistedState {
  Map<int, Map<String, User>> users;
  List<PageModel> pages;
 Map<int, Config?> configs;
 Database db;

  PersistedState({required this.users, required this.pages, required this.configs, required this.db});
}
