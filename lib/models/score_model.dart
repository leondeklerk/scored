class ScoreModel {
  final int pageId;
  final String userId;
  final int score;

  const ScoreModel(
      {required this.userId, required this.pageId, required this.score});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pageId': pageId,
      'score': score,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{pageId: $pageId, userId: $userId, score: $score}';
  }
}
