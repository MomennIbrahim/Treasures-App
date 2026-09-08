import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class DemoProductDetailsData {
  static const ProductDetailsModel product = ProductDetailsModel(
    id: 1,
    name: 'Burberry Her',
    images: [
      'https://i.pinimg.com/736x/cd/78/f8/cd78f82c6f052162af45b1b2fead67fc.jpg',
      'https://i.pinimg.com/736x/21/21/02/212102f4ba55638278c66c234e546fb0.jpg',
      'https://i.pinimg.com/1200x/6f/38/b9/6f38b9344e3e1d74ea3427b2365c4860.jpg',
    ],
    sizes: [
      ProductSizeModel(
        id: 1,
        value: 30,
        unit: 'ml',
        price: 800,
        oldPrice: 1000,
        discountPercentage: 20,
        stock: 15,
      ),
      ProductSizeModel(
        id: 2,
        value: 50,
        unit: 'ml',
        price: 1200,
        oldPrice: 1500,
        discountPercentage: 20,
        stock: 10,
      ),
      ProductSizeModel(
        id: 3,
        value: 100,
        unit: 'ml',
        price: 2000,
        oldPrice: 2500,
        discountPercentage: 20,
        stock: 5,
      ),
    ],
    longevity: 'Long Lasting',
    sillage: 'Strong',
    rate: 4.8,
    description:
        'A beautiful feminine fragrance with a sweet and elegant character.',
    howToUse: HowToUseModel(
      title: 'How to use',
      steps: [
        'Spray on pulse points.',
        'Spray on neck and wrists.',
        'Do not rub after spraying.',
      ],
    ),
    ingredients: ['Alcohol', 'Parfum', 'Aqua', 'Limonene', 'Linalool'],
    details:
        'A modern feminine fragrance suitable for everyday use and special occasions.',
  );
}
