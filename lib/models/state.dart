import 'package:scored/models/config_model.dart';
import 'package:scored/models/user.dart';

class PersistedState {
  List<User> users;
  ConfigModel? config;

  PersistedState({required this.users, required this.config});
}
