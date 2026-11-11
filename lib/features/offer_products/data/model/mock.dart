import 'package:konoz/core/shared_model.dart/product_item_model.dart';

/// داتا مؤقتة لحد ما الـ API يجهز. بتتبني بنفس شكل Supabase
/// عن طريق ProductItemModel.fromSupabase (images + product_sizes).
/// امسح الملف ده لما تربط الداتا الحقيقية.
List<ProductItemModel> buildMockOfferProducts() {
  const names = [
    'Dior Sauvage',
    'Chanel Bleu',
    'Tom Ford Oud Wood',
    'Versace Eros',
    'Royal Oud',
    'Musk Al Tahara',
    'Creed Aventus',
    'Bakhoor Gold',
    'YSL Libre',
    'Armani Code',
  ];

  const descriptions = [
    'عطر رجالي منعش بنفحات البرغموت والفلفل، ثبات عالي ومناسب للاستخدام اليومي.',
    'عطر أنيق بتركيبة حمضيات وخشبية، مثالي للمناسبات الرسمية والعمل.',
    'عطر شرقي فاخر بخشب العود والتوابل، فواحية قوية ومميزة.',
    'عطر جذاب بنفحات النعناع والتفاح الأخضر والفانيليا، مناسب للسهرات.',
    'عود ملكي بدرجات دافئة من العنبر والمسك، ثبات يدوم طول اليوم.',
    'مسك ناعم ونظيف برائحة هادئة، مناسب للاستخدام اليومي والصلاة.',
    'عطر فاخر بنفحات الأناناس والبتولا والمسك، من أشهر عطور الرجال.',
    'بخور فاخر بالعود والصندل، يعطي المكان رائحة شرقية دافئة.',
    'عطر نسائي بالزهور البيضاء والفانيليا، أنوثة وجرأة في آن واحد.',
    'عطر رجالي ناعم بالتوابل والخشب، ثبات متوسط وفواحية هادئة.',
  ];

  // (price, discount_price, discount_percentage)
  const prices = [
    [2400, 1800, '50%'],
    [2800, 2100, '50%'],
    [3500, 2800, '50%'],
    [1900, 1520, '50%'],
    [1500, 1050, '50%'],
    [900, 720, '50%'],
    [4200, 3150, '50%'],
    [700, 490, '50%'],
    [2600, 2080, '50%'],
    [2200, 1760, '50%'],
  ];

  return List.generate(names.length, (i) {
    final p = prices[i];
    return ProductItemModel.fromSupabase({
      'id': 1000 + i,
      'name': names[i],
      'description': descriptions[i],
      'images': ['https://picsum.photos/seed/offer$i/400/400'],
      'rating': 4.0 + (i % 10) / 10,
      'review_count': 20 + i * 7,
      'product_sizes': [
        {
          'id': 5000 + i,
          'value': 100,
          'unit': 'ml',
          'price': p[0],
          'discount_price': p[1],
          'discount_percentage': p[2],
          'in_stock': 10,
        },
      ],
    });
  });
}
