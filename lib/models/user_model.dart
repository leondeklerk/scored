class UserModel {
  final String id;
  final String name;
  final int pageId;

  const UserModel({
    required this.id,
    required this.name,
    required this.pageId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pageId': pageId,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{id: $id, score: $name, pageId: $pageId}';
  }
}
