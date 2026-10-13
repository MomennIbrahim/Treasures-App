import 'package:flutter/material.dart';
import 'package:konoz/core/di/dependency_injection.dart';
import 'package:konoz/features/auth/presentation/ui/widgets/auth_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

bool get isLoggedIn => getIt<SupabaseClient>().auth.currentSession != null;

Future<bool> requireLogin(BuildContext context) async {
  if (isLoggedIn) return true;
  final ok = await showLoginSheet(context);
  return ok && isLoggedIn;
}
