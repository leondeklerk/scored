class RoundModel {
  final String id;
  final int number;
  final int pageId;
  final String userId;

  const RoundModel(
      {required this.id,
      required this.number,
      required this.userId,
      required this.pageId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'userId': userId,
      'pageId': pageId,
    };
  }

  @override
  String toString() {
    return 'RoundModel{id: $id, number: $number, pageId: $pageId, userId: $userId}';
  }
}
