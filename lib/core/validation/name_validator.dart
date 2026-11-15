String? validateName(String? v) {
  final value = v?.trim() ?? '';
  if (value.isEmpty) return 'Please enter your name';
  if (value.length < 3) return 'Name must be at least 3 characters';
  return null;
}
