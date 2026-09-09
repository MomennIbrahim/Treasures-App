import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/best_selling_model.dart';

class DemoBestSellingData {
  static final BestSellingModel demo = BestSellingModel(
    success: true,
    message: 'Best Selling',
    products: [
      ProductItemModel(
        id: 1,
        name: 'Dior Sauvage',
        description: 'A bold and fresh fragrance for confident men.',
        image:
            'https://i.pinimg.com/736x/0e/b7/69/0eb7695a4cc9e3c863d9945844458588.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '30',
        rating: '4.9',
        reviewCount: '210',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 2,
        name: 'Chanel No. 5',
        description: 'A timeless floral fragrance for elegant women.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',
        price: '600',
        discountPrice: '450',
        discountPercentage: '25',
        rating: '4.9',
        reviewCount: '340',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 3,
        name: 'Tom Ford Oud Wood',
        description: 'A rich and warm oud fragrance for both men and women.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
        price: '900',
        discountPrice: null,
        discountPercentage: null,
        rating: '4.7',
        reviewCount: '98',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 4,
        name: 'Versace Eros',
        description: 'A powerful and seductive fragrance.',
        image:
            'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
        price: '480',
        discountPrice: '320',
        discountPercentage: '33',
        rating: '4.6',
        reviewCount: '156',
        inStock: false,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
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