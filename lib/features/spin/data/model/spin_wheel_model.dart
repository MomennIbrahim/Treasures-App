import 'package:flutter/material.dart';

/// رد `GET /spin-wheel`: { data: { enabled, hasSpin, sections: [{id, label, color}] } }
class SpinWheelModel {
  final bool enabled;
  final bool hasSpin;
  final List<SpinSection> sections;

  const SpinWheelModel({
    required this.enabled,
    required this.sections,
    required this.hasSpin,
  });

  factory SpinWheelModel.fromApi(Map<String, dynamic> body) {
    final raw = body['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : body;
    final list = data['sections'];
    return SpinWheelModel(
      enabled: data['enabled'] == true,
      hasSpin: data['hasSpin'] == true,
      sections: list is List
          ? list
                .whereType<Map>()
                .map((e) => SpinSection.fromApi(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
    );
  }

  SpinWheelModel copyWith({bool? enabled, bool? hasSpin}) => SpinWheelModel(
    enabled: enabled ?? this.enabled,
    hasSpin: hasSpin ?? this.hasSpin,
    sections: sections,
  );
}

/// قطاع في العجلة (وبنفس الشكل نتيجة اللفّة)
class SpinSection {
  final int id;
  final String label;
  final Color color;

  const SpinSection({
    required this.id,
    required this.label,
    required this.color,
  });

  factory SpinSection.fromApi(Map<String, dynamic> json) {
    return SpinSection(
      id: json['id'] is num
          ? (json['id'] as num).toInt()
          : int.tryParse('${json['id']}') ?? 0,
      label: (json['label'] ?? '').toString(),
      color: _parseColor(json['color']),
    );
  }

  /// الـ API مش بيرجّع نوع للقطاع، فبنعرف "حظ أوفر" من النص.
  /// لما يضيفوا حقل `type` بدّل الـ getter ده بيه.
  bool get isTryAgain {
    final l = label.toLowerCase();
    return l.contains('better luck') || label.contains('حظ');
  }

  /// "#C45C26" → Color
  static Color _parseColor(dynamic value) {
    const fallback = Color(0xFF7C3AED);
    final hex = value?.toString().replaceAll('#', '').trim() ?? '';
    if (hex.length != 6) return fallback;
    final parsed = int.tryParse(hex, radix: 16);
    return parsed == null ? fallback : Color(0xFF000000 | parsed);
  }
}