import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/home/data/model/currently_trending_model.dart';
import 'package:konoz/features/product_details/data/model/product_details_model.dart';

class DemoCurrentlyTrendingData {
  static final CurrentlyTrendingModel demo = CurrentlyTrendingModel(
    success: true,
    message: 'Currently Trending',
    products: [
      ProductItemModel(
        id: "5",
        name: 'Bleu de Chanel',
        description: 'An elegant and fresh fragrance for men.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',

        rating: '4.8',
        reviewCount: '154',
        inStock: true,
        defaultSize: '50ml',
        defaultPrice: '500',
        defaultDiscountPrice: "350 EGP",
        defaultDiscountPercentage: "35%",
        isFavorite: false,
        sizes: [
          ProductSizeModel(
            id: "2",
            value: 30,
            unit: 'ml',
            priceWithDiscount: "800",
            priceWithoutDiscount: "1000",
            discountPercentage: "20%",

            stock: 15,
          ),
        ],
      ),
      ProductItemModel(
        id: "6",
        name: 'YSL Y',
        description: 'A fresh and modern fragrance with a bold character.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',

        rating: '4.7',
        reviewCount: '132',
        defaultPrice: '500',
        defaultDiscountPrice: "350 EGP",
        defaultDiscountPercentage: "35%",
        inStock: true,
        isFavorite: false,
        sizes: [],
        defaultSize: '50ml',
      ),
      ProductItemModel(
        id: "7",
        defaultSize: '50ml',
        name: 'Armani Code',
        description: 'A sophisticated and warm fragrance.',
        image:
            'https://i.pinimg.com/736x/91/46/b1/9146b1806b9cc89d22d12ccb987e0d5a.jpg',

        rating: '4.6',
        reviewCount: '87',
        inStock: true,
        isFavorite: false,
        sizes: [
          ProductSizeModel(
            id: "1",
            value: 30,
            unit: 'ml',
            priceWithDiscount: "800",
            priceWithoutDiscount: "1000",
            discountPercentage: "20%",
            stock: 15,
          ),
        ],
        defaultPrice: '500',
        defaultDiscountPrice: "350 EGP",
        defaultDiscountPercentage: "35%",
      ),
      ProductItemModel(
        defaultSize: '50ml',
        id: "8",
        name: 'Acqua di Gio',
        description: 'A fresh aquatic fragrance with a timeless character.',
        image:
            'https://img.pikbest.com/wp/202413/aroma-men-s-perfume-plant-leaves-promotional-web-banner_9087731.jpg!sw800',

        rating: '4.8',
        reviewCount: '176',
        inStock: true,
        isFavorite: false,
        sizes: [
          ProductSizeModel(
            id: "1",
            value: 30,
            unit: 'ml',
            priceWithDiscount: "800",
            priceWithoutDiscount: "1000",
            discountPercentage: "20%",
            stock: 15,
          ),
        ],
        defaultPrice: '500',
        defaultDiscountPrice: "350EGP",
        defaultDiscountPercentage: "35%",
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
