class PendingRoute {
  static String? _value;
  static set value(String? v) => _value = v;

  /// بيرجّع القيمة ويمسحها (مرة واحدة)
  static String? take() {
    final v = _value;
    _value = null;
    return (v != null && v.startsWith('/')) ? v : null;
  }
}