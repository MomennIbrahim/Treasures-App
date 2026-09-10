class AddressModel {
  final String id;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? extraDetails; // شقة 12 عقار 27 مثلاً
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.extraDetails,
    this.isDefault = false,
  });

  /// النص الكامل اللي هيتعرض: العنوان + التفاصيل لو موجودة
  String get displayText {
    if (extraDetails == null || extraDetails!.trim().isEmpty) {
      return formattedAddress;
    }
    return '$formattedAddress، $extraDetails';
  }

  AddressModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    String? formattedAddress,
    String? extraDetails,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      extraDetails: extraDetails ?? this.extraDetails,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}