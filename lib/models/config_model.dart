class ConfigModel {
  int ranked;
  int reversed;
  final int pageId;

  ConfigModel(
      {      required this.ranked,
      required this.reversed,
      required this.pageId});

  Map<String, dynamic> toMap() {
    return {
      'ranked': ranked,
      'reversed': reversed,
      'pageId': pageId,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{ranked: $ranked, reversed: $reversed, pageId: $pageId}';
  }
}
