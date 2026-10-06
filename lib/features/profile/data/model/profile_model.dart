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

  factory ProfileModel.empty() => const ProfileModel(
        id: '',
        name: 'User name',
        phone: '+20000000000',
        email: 'email@example.com',
        avatarUrl: "asdasd" ,
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
  List<Object?> get props => [id, name, phone, email, addresses];
}

class AddressModel extends Equatable {
  final int id;
  final String title;
  final String fullAddress;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final parts = [
      json['street'],
      json['building'],
      json['area'],
      json['city'],
    ].where((e) => e != null && e.toString().trim().isNotEmpty);

    return AddressModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      fullAddress: parts.join(', '),
      isDefault: json['is_default'] == true,
    );
  }

  @override
  List<Object?> get props => [id, title, fullAddress, isDefault];
}