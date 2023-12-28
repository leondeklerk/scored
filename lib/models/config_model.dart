class ConfigModel {
  final int id;
  final int ranked;
  final int reversed;
  final int pages;

  const ConfigModel(
      {required this.id,
      required this.ranked,
      required this.reversed,
      required this.pages});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ranked': ranked,
      'reversed': reversed,
      'pages': pages,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{id: $id, ranked: $ranked, reversed: $reversed, pages: $pages}';
  }
}
