import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo.dart';
import 'package:konoz/features/collection_products/data/repo/collection_products_repo_implmentation.dart';
import 'package:konoz/features/collection_products/presentation/controllers/collection_products/collection_products_cubit.dart';
import 'package:konoz/features/collections/data/repo/collections_repo.dart';
import 'package:konoz/features/collections/data/repo/collections_repo_implementation.dart';
import 'package:konoz/features/collections/presentation/controllers/collections/collections_cubit.dart';
import 'package:konoz/features/home/data/repo/home_repo.dart';
import 'package:konoz/features/home/data/repo/home_repo_implementation.dart';
import 'package:konoz/features/home/presentation/controllers/banners_cubit/banners_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/best_selling/best_selling_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/currently_trending/currently_trending_cubit.dart';
import 'package:konoz/features/home/presentation/controllers/packages_cubit.dart';
import 'package:konoz/features/layout/presentation/controller/layout_cubit.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo_implmentation.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  /// Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  /// Api Service
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  /*
  /// Location
  getIt.registerLazySingleton<LocationService>(() => LocationService());

  /// Notification Service (Firebase Messaging)
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService.instance,
  );
*/
  /// All Repositories ====>

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImplementation(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CollectionsRepo>(
    () => CollectionsRepoImplementation(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepoImplementation(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CollectionProductsRepo>(
    () => CollectionProductsRepoImplementation(getIt<ApiService>()),
  );
  /*
  // Profile Repository
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImplementation(getIt<ApiService>()),
  );
 */

  //ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ

  /// All Cubits ====>

  // Layout Cubits
  getIt.registerFactory<LayoutCubit>(() => LayoutCubit());

  // Home Cubits
  getIt.registerLazySingleton<BannersCubit>(() => BannersCubit());
  getIt.registerLazySingleton<BestSellingCubit>(() => BestSellingCubit());
  getIt.registerLazySingleton<CurrentlyTrendingCubit>(
    () => CurrentlyTrendingCubit(),
  );
  getIt.registerLazySingleton<PackagesCubit>(() => PackagesCubit());

  // Collections Cubits
  getIt.registerLazySingleton<CollectionsCubit>(() => CollectionsCubit());

  // Product Details Cubit
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getIt()),
  );

  // Collection Products Cubit
  getIt.registerFactory<CollectionProductsCubit>(
    () => CollectionProductsCubit(),
  );
}
