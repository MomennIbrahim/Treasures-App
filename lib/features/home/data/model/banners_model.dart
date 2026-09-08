class BannersModel {
  final bool? success;
  final String? message;
  final List<BannerData>? bannersData;

  BannersModel({required this.bannersData, this.success, this.message});

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    return BannersModel(
      success: json['success'],
      message: json['message'],
      bannersData: json['data'] == null
          ? null
          : (json['data'] as List).map((e) => BannerData.fromJson(e)).toList(),
    );
  }
}

class BannerData {
  final String image;
  final String title;
  final String subtitle;
  final String buttonLabel;

  BannerData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
  });

  // Empty data model
  BannerData.empty()
    : image = 'asd.png',
      title = 'Fake Title',
      subtitle = 'Fake Subtitle',
      buttonLabel = 'Fake Button Label';

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      buttonLabel: json['buttonLabel'],
    );
  }
}
