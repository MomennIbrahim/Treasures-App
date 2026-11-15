
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResponseModel extends Equatable {
  final String token;
  final String refreshToken;
  final int expiresIn;
  final UserModel user;
  final bool isNewUser;

  const AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
    required this.isNewUser,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return AuthResponseModel(
      token: data['token']?.toString() ?? '',
      refreshToken: data['refresh_token']?.toString() ?? '',
      expiresIn: int.tryParse(data['expires_in'].toString()) ?? 0,
      user: UserModel.fromJson(
        data['user'] as Map<String, dynamic>? ?? {},
      ),
      isNewUser: data['is_new_user'] == true,
    );
  }

  @override
  List<Object?> get props => [
    token,
    refreshToken,
    expiresIn,
    user,
    isNewUser,
  ];
}

class UserModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final String? avatarUrl;
  final String? createdAt;
  final List<dynamic> addresses;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.avatarUrl,
    this.createdAt,
    this.addresses = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      createdAt: json['created_at']?.toString(),
      addresses: json['addresses'] as List? ?? [],
    );
  }

  factory UserModel.fromSupabase(User user) {
    return UserModel(
      id: user.id,
      name: user.userMetadata?['name']?.toString() ?? '',
      email: user.email,
      phone: user.phone ?? '',
      avatarUrl: user.userMetadata?['avatar_url']?.toString(),
      createdAt: user.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    avatarUrl,
    createdAt,
    addresses,
  ];
}
