class PageModel {
  final int id;
  final String name;
  final double order;

  const PageModel({
    required this.id,
    required this.name,
    required this.order
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'order': order,
    };
  }

  @override
  String toString() {
    return 'PageModel{id: $id, score: $name, order: $order}';
  }
}
