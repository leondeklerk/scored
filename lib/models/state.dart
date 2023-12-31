import 'package:scored/models/config_model.dart';
import 'package:scored/models/user.dart';

class PersistedState {
  Map<int, Map<String, User>> users;
  List<String> pages;
  ConfigModel? config;

  PersistedState({required this.users, required this.pages, required this.config});
}
