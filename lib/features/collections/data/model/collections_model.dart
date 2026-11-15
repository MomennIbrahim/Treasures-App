class CollectionsModel {
  final String id;
  final String name;

  const CollectionsModel({required this.id, required this.name});

  factory CollectionsModel.fromJson(Map<String, dynamic> json) {
    return CollectionsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
