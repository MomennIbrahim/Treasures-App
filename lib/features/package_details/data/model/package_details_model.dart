/// منتج جوه الباكدج (بيتعرض كارت صغير).
class PackageProductModel {
  final int id;
  final String name;
  final String image;
  final String sizeLabel; // مثلًا "100 ml"

  const PackageProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.sizeLabel,
  });
}

/// تفاصيل الباكدج: نفس معلومات المنتج من غير sizes ولا notes.
class PackageDetailsModel {
  final int id;
  final String name;
  final String description;
  final List<String> howToUse;
  final double rate;
  final int reviewCount;
  final String longevity;
  final String sillage;
  final num price;
  final num discountPrice; // 0 = مفيش خصم
  final List<String> images; // صور الباكدج (من الداشبورد)
  final List<PackageProductModel> products; // 3 - 6 منتجات (متغير)

  const PackageDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.howToUse,
    required this.rate,
    required this.reviewCount,
    required this.longevity,
    required this.sillage,
    required this.price,
    required this.discountPrice,
    required this.images,
    required this.products,
  });

  bool get hasDiscount => discountPrice > 0 && discountPrice < price;
  num get finalPrice => hasDiscount ? discountPrice : price;
  int get discountPercent =>
      hasDiscount ? (((price - discountPrice) / price) * 100).round() : 0;

  /// داتا مؤقتة لحد ما الـ API يجهز. [itemsCount] من 3 لـ 6.
  factory PackageDetailsModel.mock({int itemsCount = 5}) {
    const names = [
      'Dior Sauvage',
      'Chanel Bleu',
      'Tom Ford Oud Wood',
      'Versace Eros',
      'Royal Oud',
      'Musk Al Tahara',
    ];
    final count = itemsCount.clamp(3, 6);

    return PackageDetailsModel(
      id: 1,
      name: 'Signature Collection',
      description:
          'باكدج مختار بعناية يجمع أشهر العطور في مجموعة واحدة بسعر أوفر، '
          'مناسب كهدية أو لتجربة أكتر من رائحة.',
      howToUse: const [
        'رش العطر على نقاط النبض: الرقبة والمعصم.',
        'ابعد الزجاجة حوالي 15 سم عن الجلد.',
        'متفركش مكان الرش عشان الرائحة تثبت أكتر.',
      ],
      rate: 4.6,
      reviewCount: 128,
      longevity: '8 - 10 h',
      sillage: 'Strong',
      price: 9800,
      discountPrice: 7350,
      images: List.generate(
        3,
        (i) => 'https://picsum.photos/seed/package$i/600/600',
      ),
      products: List.generate(
        count,
        (i) => PackageProductModel(
          id: 1000 + i,
          name: names[i],
          image: 'https://picsum.photos/seed/offer$i/400/400',
          sizeLabel: '100 ml',
        ),
      ),
    );
  }
}
