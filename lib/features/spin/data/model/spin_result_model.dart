/// رد `POST /spin-wheel/spins` (بعد ما العجلة تقف ونسجّل اللفّة):
/// { data: { sectionId, label, message, prize, value, points, discountPercent, offer } }
class SpinResultModel {
  final int sectionId;
  final String label;

  /// رسالة جاهزة للعرض من السيرفر (مترجمة حسب Accept-Language)
  final String message;

  /// نوع الجايزة: `points` | ... (قيم تانية ممكن تظهر لاحقًا)
  final String prize;
  final num value;
  final int points;
  final num discountPercent;

  /// عرض/كوبون لو الجايزة خصم (null لو مفيش)
  final Map<String, dynamic>? offer;

  const SpinResultModel({
    required this.sectionId,
    required this.label,
    required this.message,
    required this.prize,
    required this.value,
    required this.points,
    required this.discountPercent,
    this.offer,
  });

  factory SpinResultModel.fromApi(Map<String, dynamic> body) {
    final raw = body['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : body;
    final offer = data['offer'];
    return SpinResultModel(
      sectionId: _toInt(data['sectionId']),
      label: (data['label'] ?? '').toString(),
      message: (data['message'] ?? '').toString(),
      prize: (data['prize'] ?? '').toString(),
      value: _toNum(data['value']),
      points: _toInt(data['points']),
      discountPercent: _toNum(data['discountPercent']),
      offer: offer is Map ? Map<String, dynamic>.from(offer) : null,
    );
  }

  static int _toInt(dynamic v) =>
      v is num ? v.toInt() : int.tryParse('$v') ?? 0;

  static num _toNum(dynamic v) => v is num ? v : (num.tryParse('$v') ?? 0);
}
