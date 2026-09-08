import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';

class DemoCurrentlyTrendingData {
  static final CurrentlyTrendingModel demo = CurrentlyTrendingModel(
    success: true,
    message: 'Currently Trending',
    products: [
      ProductItemModel(
        id: 5,
        name: 'Bleu de Chanel',
        description: 'An elegant and fresh fragrance for men.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.8',
        reviewCount: '154',
        inStock: true,
      ),
      ProductItemModel(
        id: 6,
        name: 'YSL Y',
        description: 'A fresh and modern fragrance with a bold character.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.7',
        reviewCount: '132',
        inStock: true,
      ),
      ProductItemModel(
        id: 7,
        name: 'Armani Code',
        description: 'A sophisticated and warm fragrance.',
        image:
            'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.6',
        reviewCount: '87',
        inStock: true,
      ),
      ProductItemModel(
        id: 8,
        name: 'Acqua di Gio',
        description: 'A fresh aquatic fragrance with a timeless character.',
        image:
            'https://img.pikbest.com/wp/202413/aroma-men-s-perfume-plant-leaves-promotional-web-banner_9087731.jpg!sw800',
        price: '500',
        discountPrice: '350',
        discountPercentage: '35',
        rating: '4.8',
        reviewCount: '176',
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
