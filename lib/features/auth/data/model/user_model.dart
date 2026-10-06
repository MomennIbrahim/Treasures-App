import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel extends Equatable {
  final String id;
  final String phone;
  final String name;

  const UserModel({required this.id, required this.phone, required this.name});

  factory UserModel.fromSupabase(User user) => UserModel(
        id: user.id,
        phone: user.phone ?? '',
        name: user.userMetadata?['name']?.toString() ?? '',
      );

  @override
  List<Object?> get props => [id, phone, name];
}