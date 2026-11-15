class BannersModel {
  final bool? success;
  final String? message;
  final List<BannerData>? bannersData;

  BannersModel({required this.bannersData, this.success, this.message});

  /// الرد من GET /banners: { "data": [ ... ] }
  factory BannersModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return BannersModel(
      success: json['success'] as bool? ?? json['succeeded'] as bool?,
      message: json['message'] as String?,
      bannersData: data is List
          ? data
                .whereType<Map<String, dynamic>>()
                .map(BannerData.fromJson)
                .toList()
          : null,
    );
  }
}

class BannerData {
  final int? id;
  final String image;
  final String title;

  /// بييجي من حقل description في الـ API، وممكن يكون فاضي.
  final String subtitle;

  /// ربط البانر بعرض / ترويج (ممكن يكونوا null).
  final int? offerId;
  final int? promotionId;

  BannerData({
    required this.image,
    required this.title,
    required this.subtitle,
    this.id,
    this.offerId,
    this.promotionId,
  });

  static List<BannerData> emptyList() => List.generate(
    3,
    (_) => BannerData(
      image: 'asd.png',
      title: 'Fake Title',
      subtitle: 'Fake Subtitle',
    ),
  );

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: _toInt(json['id']),
      image: json['image']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['description']?.toString() ?? '',
      offerId: _toInt(json['offer_id']),
      promotionId: _toInt(json['promotion_id']),
    );
  }

  static int? _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value');
}