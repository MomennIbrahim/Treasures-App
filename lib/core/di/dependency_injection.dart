import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/core/networking/connectivity_service.dart';
import 'package:konoz/core/notifications/notification_service.dart';
import 'package:konoz/core/router/app_router.dart';
import 'package:konoz/features/auth/data/repo/auth_repo.dart';
import 'package:konoz/features/auth/data/repo/auth_repo_implmentation.dart';
import 'package:konoz/features/auth/presentation/controllers/google_signin/google_sign_in_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/login/login_cubit.dart';
import 'package:konoz/features/auth/presentation/controllers/register_otp/register_cubit.dart';
import 'package:konoz/features/cart/data/repo/cart_repo.dart';
import 'package:konoz/features/cart/data/repo/cart_repo_implementation.dart';
import 'package:konoz/features/cart/presentation/controller/cart/cart_cubit.dart';
import 'package:konoz/features/checkout/data/repo/checkout_repo.dart';
import 'package:konoz/features/checkout/data/repo/checkout_repo_implementation.dart';
import 'package:konoz/features/checkout/presentation/controllers/checkout/checkout_cubit.dart';
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
import 'package:konoz/features/order_details/data/repo/order_details_repo.dart';
import 'package:konoz/features/order_details/data/repo/order_details_repo_implementation.dart';
import 'package:konoz/features/order_details/presentation/controllers/order_details/order_details_cubit.dart';
import 'package:konoz/features/orders/data/repo/orders_repo.dart';
import 'package:konoz/features/orders/data/repo/orders_repo_implementation.dart';
import 'package:konoz/features/orders/presentation/controllers/orders/orders_cubit.dart';
import 'package:konoz/features/package_details/data/repo/package_details_repo.dart';
import 'package:konoz/features/package_details/data/repo/package_details_repo_implementation.dart';
import 'package:konoz/features/package_details/presentation/controller/package_details_cubit.dart';
import 'package:konoz/features/personal_data/presentation/controllers/addresses/addresses_cubit.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo.dart';
import 'package:konoz/features/product_details/data/repo/product_details_repo_implmentation.dart';
import 'package:konoz/features/product_details/presentation/controllers/product_details/product_details_cubit.dart';
import 'package:konoz/features/profile/data/repo/profile_repo.dart';
import 'package:konoz/features/profile/data/repo/profile_repo_implementation.dart';
import 'package:konoz/features/profile/presentation/controllers/profile/profile_cubit.dart';
import 'package:konoz/features/search/data/repo/search_repo.dart';
import 'package:konoz/features/search/data/repo/search_repo_implmentation.dart';
import 'package:konoz/features/search/presentation/controllers/search/search_cubit.dart';
import 'package:konoz/features/settings/presentation/controllers/logout/logout_cubit.dart';
import 'package:konoz/features/spin/data/repo/spin_repo.dart';
import 'package:konoz/features/spin/data/repo/spin_repo_implementation.dart';
import 'package:konoz/features/spin/presentation/controllers/spin/spin_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ───────────── Networking (Laravel API) ─────────────
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(getIt<Connectivity>()),
  );

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(getIt<Dio>(), getIt<ConnectivityService>()),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(AppRouter.router, getIt()),
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
    () => AuthRepoImplmentation(getIt<ApiService>()),
  );

  // ── على الـ API ──
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImplementation(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CollectionsRepo>(
    () => CollectionsRepoImplementation(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CollectionProductsRepo>(
    () => CollectionProductsRepoImplementation(getIt<ApiService>()),
  );

  // ── لسه على Supabase ──
  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepoImplementation(getIt<ApiService>()),
  );

  // Profile Repository
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImplementation(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CartRepo>(() => CartRepoImplementation(getIt()));

  getIt.registerFactory<CheckoutRepo>(
    () => CheckoutRepoImplementation(getIt()),
  );

  // Search Repository
  getIt.registerLazySingleton<SearchRepo>(() => SearchRepoImplementation());

  // Orders Repository
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImplementation(getIt()),
  );

  // Orders Repository
  getIt.registerLazySingleton<OrderDetailsRepo>(
    () => OrderDetailsRepoImplementation(getIt()),
  );

  // Package Details Repository
  getIt.registerLazySingleton<PackageDetailsRepo>(
    () => PackageDetailsRepoImplementation(getIt()),
  );

  // Spin Repository
  getIt.registerLazySingleton<SpinRepo>(() => SpinRepoImplementation(getIt()));
  //ــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ

  /// All Cubits ====>

  // Auth Cubits
  getIt.registerFactory<RegisterCubit>(() => RegisterCubit(getIt()));
  getIt.registerFactory<GoogleSignInCubit>(() => GoogleSignInCubit(getIt()));
  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));
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

  // Cart Cubit
  getIt.registerLazySingleton<CartCubit>(() => CartCubit(getIt()));

  // Checkout Cubit
  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(getIt(), getIt<CartCubit>()),
  );

  // Search Cubit
  getIt.registerFactory<SearchCubit>(() => SearchCubit(getIt()));

  // Orders Cubit
  getIt.registerFactory<OrdersCubit>(() => OrdersCubit(getIt()));

  // Order Details Cubit
  getIt.registerFactory<OrderDetailsCubit>(() => OrderDetailsCubit(getIt()));

  // Package Details Cubit
  getIt.registerFactory<PackageDetailsCubit>(
    () => PackageDetailsCubit(getIt(), getIt<CartCubit>()),
  );

  // Spin Cubit
  getIt.registerFactory<SpinCubit>(() => SpinCubit(getIt()));
}
