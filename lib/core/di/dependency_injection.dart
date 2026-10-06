import 'package:get_it/get_it.dart';
import 'package:konoz/core/networking/supabase_db_service.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';
import 'package:konoz/features/auth/data/repo/auth_repo_implmentation.dart';
import 'package:konoz/features/auth/presentation/controllers/send_otp/send_otp_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/verify_otp/verify_otp_cubit.dart';
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
import 'package:konoz/features/profile/data/repo/profile_repo.dart';
import 'package:konoz/features/profile/data/repo/profile_repo_implementation.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/features/settings/presentation/controllers/logout/logout_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getIt.registerLazySingleton<SupabaseDbService>(
    () => SupabaseDbService(getIt<SupabaseClient>()),
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
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImplmentation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImplementation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<CollectionsRepo>(
    () => CollectionsRepoImplementation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepoImplementation(getIt<SupabaseDbService>()),
  );

  getIt.registerLazySingleton<CollectionProductsRepo>(
    () => CollectionProductsRepoImplementation(getIt<SupabaseDbService>()),
  );

  // Profile Repository
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImplementation(getIt()),
  );

  //ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ

  /// All Cubits ====>

  // Auth Cubits
  getIt.registerFactory<SendOtpCubit>(() => SendOtpCubit(getIt()));
  getIt.registerFactory<VerifyOtpCubit>(() => VerifyOtpCubit(getIt()));
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt()));

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

  getIt.registerLazySingleton<ProfileCubit>(() => ProfileCubit(getIt()));

  // Address Cubit
  getIt.registerFactory<AddressesCubit>(() => AddressesCubit());
}
