/// عنوان من الـ API: { id, title, fullAddress, isDefault, lat, lng }
class AddressModel {
  final int id;
  final String title;
  final String fullAddress;
  final bool isDefault;
  final double? lat;
  final double? lng;

  const AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.isDefault = false,
    this.lat,
    this.lng,
  });

  factory AddressModel.fromApi(Map<String, dynamic> json) {
    return AddressModel(
      id: _toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      // بنتحمل كمان شكل Supabase القديم (full_address / is_default)
      fullAddress: (json['fullAddress'] ?? json['full_address'] ?? '')
          .toString(),
      isDefault: _toBool(json['isDefault'] ?? json['is_default']),
      lat: _toDouble(json['lat']),
      lng: _toDouble(json['lng']),
    );
  }

  /// alias للكود القديم (ProfileModel.fromJson)
  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      AddressModel.fromApi(json);

  /// للـ Skeletonizer
  factory AddressModel.empty() => const AddressModel(
    id: 0,
    title: 'Home address',
    fullAddress: 'Street name, area name, city name',
    isDefault: false,
  );

  AddressModel copyWith({bool? isDefault}) => AddressModel(
    id: id,
    title: title,
    fullAddress: fullAddress,
    isDefault: isDefault ?? this.isDefault,
    lat: lat,
    lng: lng,
  );

  static int _toInt(dynamic v) =>
      v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);

  static double? _toDouble(dynamic v) =>
      v == null ? null : (v is num ? v.toDouble() : double.tryParse('$v'));

  static bool _toBool(dynamic v) =>
      v == true || v == 1 || v == '1' || v == 'true';
}
