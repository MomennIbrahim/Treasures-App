import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatarUrl;
  final List<AddressModel> addresses;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.addresses,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    List<AddressModel>? addresses,
    String? phone,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl,
      addresses: addresses ?? this.addresses,
    );
  }

  factory ProfileModel.empty() => const ProfileModel(
    id: '',
    name: 'User name',
    phone: '+20000000000',
    email: 'email@example.com',
    avatarUrl: "asdasd",
    addresses: [
      AddressModel(id: 0, title: 'Home', fullAddress: 'Placeholder address'),
    ],
  );

  factory ProfileModel.fromJson(
    Map<String, dynamic> json, {
    List<AddressModel> addresses = const [],
  }) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      addresses: addresses,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, email, avatarUrl, addresses];
}

class AddressModel extends Equatable {
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

  AddressModel copyWith({bool? isDefault}) => AddressModel(
    id: id,
    title: title,
    fullAddress: fullAddress,
    isDefault: isDefault ?? this.isDefault,
    lat: lat,
    lng: lng,
  );

  /// الـ API بيرجّع camelCase (fullAddress / isDefault).
  /// لسه بنتحمل شكل Supabase القديم (full_address / is_default) احتياطًا.
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    // الأولوية للعنوان النصي من الخريطة، وإلا نجمع الحقول اليدوية
    final manual = [
      json['street'],
      json['building'],
      json['area'],
      json['city'],
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(', ');
    final full = (json['fullAddress'] ?? json['full_address'])?.toString() ?? '';
    final def = json['isDefault'] ?? json['is_default'];

    return AddressModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      fullAddress: full.isNotEmpty ? full : manual,
      isDefault: def == true || def == 1 || def == '1' || def == 'true',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [id, title, fullAddress, isDefault, lat, lng];
}