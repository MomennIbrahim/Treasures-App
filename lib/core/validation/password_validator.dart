String? validateNewPassword(String? v) {
  final value = v ?? '';
  if (value.isEmpty) return 'Please enter a password';
  if (value.length < 8) return 'Password must be at least 8 characters';
  return null;
}

/// للدخول: مطلوب بس (متفضحش القواعد)
String? validateRequiredPassword(String? v) =>
    (v == null || v.isEmpty) ? 'Please enter your password' : null;
