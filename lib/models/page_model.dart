class PageModel {
  final int id;
  final String name;

  const PageModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'PageModel{id: $id, score: $name}';
  }
}
