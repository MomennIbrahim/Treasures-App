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

    notes: FragranceNotesModel(
      topNotes: [
        FragranceNoteModel(
          id: 1,
          name: 'Strawberry',
          image: 'https://i.pinimg.com/736x/3e/ee/1c/3eee1c2c0d6da80552ee400dd70e44df.jpg',
        ),
        FragranceNoteModel(
          id: 2,
          name: 'Bergamot',
          image: 'https://i.pinimg.com/1200x/05/d7/d0/05d7d0202f956707406ac190b014352e.jpg',
        ),
        FragranceNoteModel(
          id: 3,
          name: 'Blackcurrant',
          image:
              'https://i.pinimg.com/736x/1f/b1/7a/1fb17ac031d799a8166e7115bda2b7b4.jpg',
        ),
      ],
      heartNotes: [
        FragranceNoteModel(
          id: 4,
          name: 'Jasmine',
          image: 'https://i.pinimg.com/736x/8b/1b/42/8b1b423135319a1f7bf36bae7f41c43e.jpg',
        ),
        FragranceNoteModel(
          id: 5,
          name: 'Violet',
          image: 'https://i.pinimg.com/736x/2b/a5/05/2ba505cb7ae0cd6bf721bf1b9f19c0a7.jpg',
        ),
        FragranceNoteModel(
          id: 6,
          name: 'Rose',
          image: 'https://i.pinimg.com/736x/a3/1b/f2/a31bf2e059e264ad1d9f76ad2d3af45e.jpg',
        ),
      ],
      baseNotes: [
        FragranceNoteModel(
          id: 7,
          name: 'Musk',
          image: 'https://i.pinimg.com/736x/42/be/e9/42bee9c1f8b42d6042dbfd8c7ef76dbb.jpg',
        ),
        FragranceNoteModel(
          id: 8,
          name: 'Vanilla',
          image: 'https://i.pinimg.com/1200x/3b/d6/22/3bd62269436f0738cd0346f962c4f800.jpg',
        ),
        FragranceNoteModel(
          id: 9,
          name: 'Amber',
          image: 'https://i.pinimg.com/1200x/f4/d9/82/f4d9821bd5be1617b50d14e473a0fe75.jpg',
        ),
        FragranceNoteModel(
          id: 10,
          name: 'Cashmeran',
          image: 'https://i.pinimg.com/1200x/58/2c/4c/582c4c81310f9baffc4a980b5f57338d.jpg',
        ),
      ],
    ),

    details:
        'A modern feminine fragrance suitable for everyday use and special occasions.',
  );
}
