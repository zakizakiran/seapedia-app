import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options); // Continue
        },
        onResponse: (response, handler) {
          return handler.next(response); // Continue
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final path = e.requestOptions.path;
            if (path.contains(ApiConstants.login) || path.contains(ApiConstants.register)) {
              return handler.next(e);
            }

            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');

            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
                final response = await refreshDio.post(
                  ApiConstants.refreshToken,
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['data']['accessToken'];
                  final newRefreshToken = response.data['data']['refreshToken'];

                  await prefs.setString('access_token', newAccessToken);
                  await prefs.setString('refresh_token', newRefreshToken);

                  final options = e.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';
                  
                  final retryResponse = await dio.fetch(options);
                  return handler.resolve(retryResponse);
                }
              } catch (refreshError) {
                if (getx.Get.isRegistered<dynamic>(tag: 'AuthService') || getx.Get.isRegistered<getx.GetxService>()) {
                  try {
                    await prefs.remove('access_token');
                    await prefs.remove('refresh_token');
                    await prefs.remove('user_data');
                    getx.Get.offAllNamed('/login');
                  } catch (_) {
                    getx.Get.offAllNamed('/login');
                  }
                } else {
                  await prefs.remove('access_token');
                  await prefs.remove('refresh_token');
                  await prefs.remove('user_data');
                  getx.Get.offAllNamed('/login');
                }
              }
            } else {
              await prefs.remove('access_token');
              await prefs.remove('refresh_token');
              await prefs.remove('user_data');
              getx.Get.offAllNamed('/login');
            }
          }
          return handler.next(e);
        },
      ),
    );
    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}
