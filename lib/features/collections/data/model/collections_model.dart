class CollectionsModel {
  final int id;
  final String name;
  final String description;
  final String image;

  const CollectionsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory CollectionsModel.fromJson(Map<String, dynamic> json) {
    return CollectionsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }
}