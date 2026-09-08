import 'package:konoz/core/shared_model.dart/pagination_model.dart';
import 'package:konoz/features/home/data/model/packages_model.dart';

class DemoPackagesData {
  static final PackagesModel demo = PackagesModel(
    success: true,
    message: 'Packages',
    packages: [
      PackageItemModel(
        id: 1,
        name: "5 Men's Perfumes That Smell Expensive",
        description:
            "A collection of premium men's fragrances at an affordable price.",
        image:
            'https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg',
        price: '5000',
        discountPrice: '2500',
        discountPercentage: '50',
        size: '100 ML',
        inStock: true,
      ),
      PackageItemModel(
        id: 2,
        name: 'Luxury Fragrance Package',
        description:
            'A premium package featuring some of our most popular fragrances.',
        image:
            'https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg',
        price: '4500',
        discountPrice: '2999',
        discountPercentage: '33',
        size: '100 ML',
        inStock: true,
      ),
      PackageItemModel(
        id: 3,
        name: 'Best Sellers Collection',
        description:
            'Our best selling fragrances collected in one special package.',
        image:
            'https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg',
        price: '5500',
        discountPrice: '3499',
        discountPercentage: '36',
        size: '100 ML',
        inStock: true,
      ),
      PackageItemModel(
        id: 4,
        name: 'Premium Men Collection',
        description:
            'A carefully selected collection of premium fragrances for men.',
        image:
            'https://i.pinimg.com/736x/ef/2f/76/ef2f767715a8c352f92e680c7e51013d.jpg',
        price: '6000',
        discountPrice: '3999',
        discountPercentage: '33',
        size: '100 ML',
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
