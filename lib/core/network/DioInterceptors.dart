
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Featurees/auth/cubit/auth_cubit.dart';


final _storage = FlutterSecureStorage();

class DioInterceptors {
  final Dio _dio;
  final AuthCubit _authCubit;

  DioInterceptors(this._dio, this._authCubit) {
    _setupDioInterceptors();
  }


  void _setupDioInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = await _storage.read(key: 'accessToken');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioError e, handler) async {
        if (e.response?.statusCode == 401) {
          final isRefreshed = await _authCubit.refreshAccessToken();
          if (isRefreshed) {
            final requestOptions = e.requestOptions;
            final newAccessToken = await _authCubit.getAccessToken();
            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await _dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          } else {
            return handler.reject(DioError(
              requestOptions: e.requestOptions,
              response: Response(
                requestOptions: e.requestOptions,
                statusCode: 403,
                statusMessage: 'Refresh token failed',
              ),
            ));
          }
        }
        return handler.next(e);
      },
    ));
  }



}
