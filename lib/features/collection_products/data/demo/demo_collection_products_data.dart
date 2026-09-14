import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/core/shared_model.dart/product_item_model.dart';
import 'package:konoz/features/collection_products/data/model/collection_products_model.dart';

class DemoCollectionProductsData {
  static final CollectionProductsModel demo = CollectionProductsModel(
    success: true,
    message: 'Collection Products',
    products: [
      ProductItemModel(
        id: 10,
        name: 'Oud Al Sultan',
        description: 'A rich and long-lasting oriental oud.',
        image:
            'https://i.pinimg.com/736x/0e/b7/69/0eb7695a4cc9e3c863d9945844458588.jpg',
        price: '700',
        discountPrice: '520',
        discountPercentage: '25',
        rating: '4.7',
        reviewCount: '112',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 11,
        name: 'Royal Musk',
        description: 'A warm musky scent suitable for all occasions.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',
        price: '450',
        discountPrice: null,
        discountPercentage: null,
        rating: '4.5',
        reviewCount: '76',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
        ],
      ),
      ProductItemModel(
        id: 12,
        name: 'Amber Nights',
        description: 'A deep amber fragrance with woody undertones.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
        price: '620',
        discountPrice: '480',
        discountPercentage: '22',
        rating: '4.6',
        reviewCount: '58',
        inStock: false,
        sizes: [
          ProductSizeModel(id: 1, size: '50ml'),
          ProductSizeModel(id: 2, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 10,
        name: 'Oud Al Sultan',
        description: 'A rich and long-lasting oriental oud.',
        image:
            'https://i.pinimg.com/736x/0e/b7/69/0eb7695a4cc9e3c863d9945844458588.jpg',
        price: '700',
        discountPrice: '520',
        discountPercentage: '25',
        rating: '4.7',
        reviewCount: '112',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 11,
        name: 'Royal Musk',
        description: 'A warm musky scent suitable for all occasions.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',
        price: '450',
        discountPrice: null,
        discountPercentage: null,
        rating: '4.5',
        reviewCount: '76',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
        ],
      ),
      ProductItemModel(
        id: 12,
        name: 'Amber Nights',
        description: 'A deep amber fragrance with woody undertones.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
        price: '620',
        discountPrice: '480',
        discountPercentage: '22',
        rating: '4.6',
        reviewCount: '58',
        inStock: false,
        sizes: [
          ProductSizeModel(id: 1, size: '50ml'),
          ProductSizeModel(id: 2, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 10,
        name: 'Oud Al Sultan',
        description: 'A rich and long-lasting oriental oud.',
        image:
            'https://i.pinimg.com/736x/0e/b7/69/0eb7695a4cc9e3c863d9945844458588.jpg',
        price: '700',
        discountPrice: '520',
        discountPercentage: '25',
        rating: '4.7',
        reviewCount: '112',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
          ProductSizeModel(id: 3, size: '100ml'),
        ],
      ),
      ProductItemModel(
        id: 11,
        name: 'Royal Musk',
        description: 'A warm musky scent suitable for all occasions.',
        image:
            'https://i.pinimg.com/736x/52/21/7e/52217e4c3e4cbc9ef40e891b8e108f2e.jpg',
        price: '450',
        discountPrice: null,
        discountPercentage: null,
        rating: '4.5',
        reviewCount: '76',
        inStock: true,
        sizes: [
          ProductSizeModel(id: 1, size: '30ml'),
          ProductSizeModel(id: 2, size: '50ml'),
        ],
      ),
      ProductItemModel(
        id: 12,
        name: 'Amber Nights',
        description: 'A deep amber fragrance with woody undertones.',
        image:
            'https://i.pinimg.com/736x/81/98/c9/8198c9e8f9925669648e1e016f040820.jpg',
        price: '620',
        discountPrice: '480',
        discountPercentage: '22',
        rating: '4.6',
        reviewCount: '58',
        inStock: false,
        sizes: [
          ProductSizeModel(id: 1, size: '50ml'),
          ProductSizeModel(id: 2, size: '100ml'),
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
