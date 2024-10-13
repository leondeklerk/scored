class SettingModel {
  String id;
  String value;

  SettingModel({
    required this.id,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }

  @override
  String toString() {
    return 'SettingModel{id: $id, value: $value}';
  }
}
