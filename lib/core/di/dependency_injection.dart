import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:konoz/core/networking/api_service.dart';
import 'package:konoz/features/layout/presentation/controller/layout_cubit.dart';

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
}
