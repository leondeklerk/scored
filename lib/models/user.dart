import 'package:uuid/uuid.dart';

class User {
  User({
    required this.name,
    required this.order,
    required this.id,
  });

  String name;
  int score = 0;
  String id = Uuid().v4();
  int rank = 0;
  int order = 0;
}
