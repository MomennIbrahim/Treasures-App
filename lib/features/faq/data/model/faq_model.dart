/// سؤال واحد من `GET /api/v1/faqs`
class FaqModel {
  final int id;
  final String question;
  final String answer;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  /// بيستخدم في الـ skeleton وقت التحميل
  factory FaqModel.empty() => const FaqModel(
    id: 0,
    question: 'Loading the question text here',
    answer: 'Loading the answer text here',
  );

  factory FaqModel.fromApi(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      question: (json['question'] ?? '').toString(),
      answer: (json['answer'] ?? '').toString(),
    );
  }

  /// بيقبل الـ body كامل (`{data: [...], meta: {...}}`) أو الـ list نفسها.
  /// لو مفيش أسئلة، data بترجع [] فبنرجّع list فاضية.
  static List<FaqModel> listFromApi(dynamic body) {
    final raw = body is Map ? body['data'] : body;
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => FaqModel.fromApi(Map<String, dynamic>.from(e)))
        .toList();
  }
}
