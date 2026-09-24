import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class DemoProductDetailsData {
  static const ProductDetailsModel product = ProductDetailsModel(
    id: 1,
    name: 'Burberry Her',

    images: [
      'https://scontent.fcai19-9.fna.fbcdn.net/v/t39.30808-6/817540417_1627542162410767_2812856740189757927_n.jpg?stp=dst-jpg_tt6&cstp=mx1024x1280&ctp=s1024x1280&_nc_cat=111&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeFluVNgKwr7UEDm7Z_Eb7bMo6M8Vka0PVyjozxWRrQ9XPcmMnpVVpbKEvFRV416EmptHpM_L5Y1ao2kiswrC06U&_nc_ohc=GWWbZmhLix4Q7kNvwFgto8Q&_nc_oc=AdoF_QtA6T0iLoVjDOFrcXYDj62Hasi_DZuTSkpuwP1US1QZPGCX_OQkFIyu7ydn7PQ&_nc_zt=23&_nc_ht=scontent.fcai19-9.fna&_nc_gid=vwlY66EcymynXR_6uTu02w&_nc_ss=7b2a8&oh=00_AQL3T4cLnH4EuGRWO4UW6bTdrjH24RoznYVviQ-fQFHNqQ&oe=6AB9B393',
      'https://scontent.fcai19-9.fna.fbcdn.net/v/t39.30808-6/785081684_1607215434443440_5722923215070030998_n.jpg?stp=dst-jpg_tt6&cstp=mx1149x1369&ctp=s1149x1369&_nc_cat=109&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=127cfc&_nc_eui2=AeHtKTmJTclfYv_5Ques8_EhsU-TPp5Atr6xT5M-nkC2vqXwQyAmj3n20Grl79lcVEUFPptQssj9GcjaZZ79SIkr&_nc_ohc=AMgRKdvVOkoQ7kNvwG4Iq3i&_nc_oc=AdpXo8ktyGPgvSsdm9gnx0pOQ6znm-KoSQ7Ou0ELP13VI6wW6wDD_EIPSkYAbQ4WCQQ&_nc_zt=23&_nc_ht=scontent.fcai19-9.fna&_nc_gid=AdMa9ebRMeK9BuNB3RaY6A&_nc_ss=7b2a8&oh=00_AQKhl5_OKl8Q67tFjijKI1Z-R3Nx56lK6oVq38zjtZY8PQ&oe=6AB9C888',
      'https://scontent.fcai19-9.fna.fbcdn.net/v/t39.30808-6/793869179_1615926706905646_7048662102310041467_n.jpg?stp=dst-jpg_tt6&cstp=mx1536x1024&ctp=s1536x1024&_nc_cat=109&_nc_map=urlgen_bucketless&ccb=1-7&_nc_sid=833d8c&_nc_eui2=AeEH1ea9tmm3c7BJsQxzn6k2qAHJ-OobCF6oAcn46hsIXsKOSkd9cAV70-1C2hYXPKlUq4rR-vSOO8QS64WuhJkI&_nc_ohc=tcDa8LsuP44Q7kNvwFG0Vuj&_nc_oc=AdoE-M4-2I7mhVV79LnFe4KOBwEfQGsDhvQKnLClXUq4FoMXCk0hfs0oPhPynCPrJOg&_nc_zt=23&_nc_ht=scontent.fcai19-9.fna&_nc_gid=_ofYl3NiYMl-wmYaGfulPg&_nc_ss=7b2a8&oh=00_AQKESbH5QeGw2H05UlqlqXaEgQD0gGrSyFUBQJcdazS7Rw&oe=6AB99B95',
    ],

    sizes: [
      ProductSizeModel(
        id: "1",
        value: "30",
        unit: 'ml',
        discountPrice: "800",
        price: "1000",
        discountPercentage: "20%",
        inStock: "15",
      ),
      ProductSizeModel(
        id: "2",
        value: "50",
        unit: 'ml',
        discountPrice: "1200",
        price: "1500",
        discountPercentage: "20%",
        inStock: "10",
      ),
      ProductSizeModel(
        id: "3",
        value: "100",
        unit: 'ml',
        discountPrice: "2000",
        price: "2500",
        discountPercentage: "20%",
        inStock: "5",
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
          image:
              'https://i.pinimg.com/736x/3e/ee/1c/3eee1c2c0d6da80552ee400dd70e44df.jpg',
        ),
        FragranceNoteModel(
          id: 2,
          name: 'Bergamot',
          image:
              'https://i.pinimg.com/1200x/05/d7/d0/05d7d0202f956707406ac190b014352e.jpg',
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
          image:
              'https://i.pinimg.com/736x/8b/1b/42/8b1b423135319a1f7bf36bae7f41c43e.jpg',
        ),
        FragranceNoteModel(
          id: 5,
          name: 'Violet',
          image:
              'https://i.pinimg.com/736x/2b/a5/05/2ba505cb7ae0cd6bf721bf1b9f19c0a7.jpg',
        ),
        FragranceNoteModel(
          id: 6,
          name: 'Rose',
          image:
              'https://i.pinimg.com/736x/a3/1b/f2/a31bf2e059e264ad1d9f76ad2d3af45e.jpg',
        ),
      ],
      baseNotes: [
        FragranceNoteModel(
          id: 7,
          name: 'Musk',
          image:
              'https://i.pinimg.com/736x/42/be/e9/42bee9c1f8b42d6042dbfd8c7ef76dbb.jpg',
        ),
        FragranceNoteModel(
          id: 8,
          name: 'Vanilla',
          image:
              'https://i.pinimg.com/1200x/3b/d6/22/3bd62269436f0738cd0346f962c4f800.jpg',
        ),
        FragranceNoteModel(
          id: 9,
          name: 'Amber',
          image:
              'https://i.pinimg.com/1200x/f4/d9/82/f4d9821bd5be1617b50d14e473a0fe75.jpg',
        ),
        FragranceNoteModel(
          id: 10,
          name: 'Cashmeran',
          image:
              'https://i.pinimg.com/1200x/58/2c/4c/582c4c81310f9baffc4a980b5f57338d.jpg',
        ),
      ],
    ),

    details:
        'A modern feminine fragrance suitable for everyday use and special occasions.',
  );
}
