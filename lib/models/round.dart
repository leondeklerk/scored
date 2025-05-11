class Round {
  String id;
  final int number;
  final Map<String, int> scores;

  Round({
    required this.id,
    required this.number,
    this.scores = const {},
  });
}
