import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio) {
    _initDio();
  }

  void _initDio() {
    _dio.options = BaseOptions(
      baseUrl: "",
      receiveDataWhenStatusError: true,
      followRedirects: false,
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    //  _addInterceptors();
  }

  // void _addInterceptors() {
  //   _dio.interceptors.addAll([
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) async {
  //         final token = await SecureCache.getData(key: SecureStorageKeys.token);

  //         final context = NavigationService.navigatorKey.currentContext;
  //         final lang =
  //             EasyLocalization.of(
  //               context!.mounted ? context : context,
  //             )?.currentLocale?.languageCode ??
  //             'ar';

  //         options.headers['Accept-Language'] = lang;
  //         if (token != null) options.headers['Authorization'] = 'Bearer $token';

  //         return handler.next(options);
  //       },
  //       onError: (error, handler) async {
  //         if (error.response?.statusCode == 401) {
  //           await SecureCache.removeData(key: SecureStorageKeys.token);
  //           final context = NavigationService.navigatorKey.currentContext;
  //           if (context != null && context.mounted) {
  //             AppToast.showWarning(
  //               context: context,
  //               title: LocaleKeys.session_expired_session_expired.tr(),
  //               description:
  //                   "${LocaleKeys.session_expired_session_expired_desc.tr()}\n${LocaleKeys.session_expired_login.tr()}",
  //             );
  //           }

  //           await Future.delayed(const Duration(seconds: 2));
  //           NavigationService.navigateToLogin();
  //         }
  //         return handler.next(error);
  //       },
  //     ),
  //     if (kDebugMode)
  //       PrettyDioLogger(
  //         requestHeader: true,
  //         requestBody: true,
  //         responseHeader: true,
  //         request: true,
  //       ),
  //   ]);
  // }

  Future<dynamic> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.post(
      endPoint,
      queryParameters: query,
      data: data,
      options: Options(
        contentType: data is FormData
            ? 'multipart/form-data'
            : 'application/json',
      ),
    );
    return response.data;
  }

  Future<dynamic> postFormData({
    required String endPoint,
    Map<String, dynamic>? query,
    required FormData data,
  }) async {
    final response = await _dio.post(
      endPoint,
      queryParameters: query,
      data: data,
      options: Options(contentType: 'multipart/form-data'),
    );
    return response.data;
  }

  Future<dynamic> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.get(
      endPoint,
      queryParameters: query,
      data: data,
    );
    return response.data;
  }

  Future<dynamic> patchData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) async {
    final response = await _dio.patch(
      endPoint,
      queryParameters: query,
      data: data,
      options: Options(
        contentType: data is FormData
            ? 'multipart/form-data'
            : 'application/json',
      ),
    );
    return response.data;
  }

  Future<dynamic> putData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) async {
    final response = await _dio.put(
      endPoint,
      queryParameters: query,
      data: data,
      options: Options(
        contentType: data is FormData
            ? 'multipart/form-data'
            : 'application/json',
      ),
    );
    return response.data;
  }

  Future<dynamic> deleteData({
    required String endPoint,
    Map<String, dynamic>? query,
    dynamic data,
  }) async {
    final response = await _dio.delete(
      endPoint,
      queryParameters: query,
      data: data,
    );
    return response.data;
  }
}
