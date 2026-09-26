import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
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
import 'package:konoz/features/personal_data/presentation/controllers/addresses/addresses_cubit.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo_implmentation.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  /// Dio
  getIt.registerLazySingleton<Dio>(() => Dio());

  /// Firestore Service
  getIt.registerLazySingleton<FirestoreService>(
    () => FirestoreService(FirebaseFirestore.instance),
  );

  getIt.registerLazySingleton<SupabaseDbService>(
    () => SupabaseDbService(Supabase.instance.client),
  );

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
    () => HomeRepoImplementation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<CollectionsRepo>(
    () => CollectionsRepoImplementation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepoImplementation(getIt<FirestoreService>()),
  );

  getIt.registerLazySingleton<CollectionProductsRepo>(
    () => CollectionProductsRepoImplementation(getIt<FirestoreService>()),
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
  getIt.registerLazySingleton<BannersCubit>(() => BannersCubit(getIt()));
  getIt.registerLazySingleton<BestSellingCubit>(
    () => BestSellingCubit(getIt()),
  );
  getIt.registerLazySingleton<CurrentlyTrendingCubit>(
    () => CurrentlyTrendingCubit(getIt()),
  );
  getIt.registerLazySingleton<PackagesCubit>(() => PackagesCubit(getIt()));

  // Collections Cubits
  getIt.registerLazySingleton<CollectionsCubit>(
    () => CollectionsCubit(getIt()),
  );

  // Product Details Cubit
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getIt()),
  );

  // Collection Products Cubit
  getIt.registerFactory<CollectionProductsCubit>(
    () => CollectionProductsCubit(getIt()),
  );

  // Address Cubit
  getIt.registerFactory<AddressesCubit>(() => AddressesCubit());
}
