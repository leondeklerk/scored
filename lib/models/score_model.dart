class ScoreModel {
  final int page;
  final int userId;
  final int score;

  const ScoreModel(
      {required this.userId, required this.page, required this.score});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'page': page,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{page: $page, userId: $userId, score: $score}';
  }
}
