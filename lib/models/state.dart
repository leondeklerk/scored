import 'package:scored/models/config.dart';
import 'package:scored/models/page_model.dart';
import 'package:scored/models/user.dart';

class PersistedState {
  Map<int, Map<String, User>> users;
  List<PageModel> pages;
 Map<int, Config?> configs;

  PersistedState({required this.users, required this.pages, required this.configs});
}
