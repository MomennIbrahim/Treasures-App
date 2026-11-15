import 'package:flutter/material.dart';
import 'package:konoz/core/constance/app_keys.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_sheet.dart';

bool get isLoggedIn => AppConstance.userToken != null;

Future<bool> requireLogin(BuildContext context) async {
  if (isLoggedIn) return true;
  final user = await showRegisterSheet(context);
  return user != null && isLoggedIn;
}
