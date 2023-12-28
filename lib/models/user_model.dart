class UserModel {
  final int userId;
  final String name;

  const UserModel({
    required this.userId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'ConfigModel{userId: $userId, score: $name}';
  }
}
