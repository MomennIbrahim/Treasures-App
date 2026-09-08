import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';

class DemoBestSellingData {
  static final BestSellingModel demo = BestSellingModel(
    success: true,
    message: 'Best selling products',
    products: [
      ProductItemModel(
        id: 1,
        name: 'Dior Sauvage',
        description: 'A fresh and powerful fragrance for men.',
        image:
            'https://i.pinimg.com/736x/0e/b7/69/0eb7695a4cc9e3c863d9945844458588.jpg',
        price: '2500',
        discountPrice: '1999',
        discountPercentage: '20',
        rating: '4.8',
        reviewCount: '125',
        inStock: true,
      ),
      ProductItemModel(
        id: 2,
        name: 'Stronger With You',
        description: 'A warm and elegant fragrance with a sweet touch.',
        image:
            'https://i.pinimg.com/736x/50/7c/ab/507cab72c06c45b560ae8a1d2779a2eb.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.7',
        reviewCount: '98',
        inStock: true,
      ),
      ProductItemModel(
        id: 3,
        name: 'Erba Pura',
        description: 'A luxurious fruity fragrance with an elegant character.',
        image:
            'https://img.pikbest.com/wp/202413/aroma-men-s-perfume-plant-leaves-promotional-web-banner_9087731.jpg!sw800',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.9',
        reviewCount: '210',
        inStock: true,
      ),
      ProductItemModel(
        id: 4,
        name: 'Khamrah',
        description: 'A rich and warm oriental fragrance.',
        image:
            'https://i.pinimg.com/736x/f5/39/92/f539929f98a01f3033231bd6e8b34254.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '17',
        rating: '4.6',
        reviewCount: '76',
        inStock: true,
      ),
    ],
    pagination: const PaginationModel(
      currentPage: 1,
      lastPage: 3,
      perPage: 10,
      total: 30,
    ),
  );
}
