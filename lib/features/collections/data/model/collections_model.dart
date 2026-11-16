class CollectionsModel {
  final String id;
  final String name;
  final String image;

  const CollectionsModel({required this.id, required this.name, required this.image});

  factory CollectionsModel.fromJson(Map<String, dynamic> json) {
    return CollectionsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}
