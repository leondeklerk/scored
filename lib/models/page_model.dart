class PageModel {
  final int id;
  final String name;
  final double order;
  final int currentRound;

  // Static MAX_NAME_LENGTH:
  static const int maxNameLength = 40;

  const PageModel(
      {required this.id,
      required this.name,
      required this.order,
      required this.currentRound});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'currentRound': currentRound,
    };
  }

  @override
  String toString() {
    return 'PageModel{id: $id, score: $name, order: $order, currentRound: $currentRound}';
  }
}
