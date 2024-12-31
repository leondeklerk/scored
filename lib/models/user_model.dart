class UserModel {
  final String id;
  final String name;
  final int pageId;
  final int order;

  const UserModel({
    required this.id,
    required this.name,
    required this.pageId,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pageId': pageId,
      'order': order,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{id: $id, score: $name, pageId: $pageId, order: $order}';
  }
}
