import 'package:uuid/uuid.dart';

class User {
  User({
    required this.name,
    required this.order,
    required this.id,
    this.score = 0,
    this.rank = 0,
  });

  static const int maxNameLength = 20;

  String name;
  int score = 0;
  String id = const Uuid().v4();
  int rank = 0;
  int order = 0;

  User copyWith({int? score, String? name}) {
    return User(
      name: name ?? this.name,
      score: score ?? this.score,
      id: id,
      order: order,
      rank: rank,
    );
  }
}
