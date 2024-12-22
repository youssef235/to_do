import 'package:dio/dio.dart';
import '../../../core/network/endpoints.dart';


class ApiAuthServices {
  final Dio _dio;

  ApiAuthServices(this._dio);

  Future<Response> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        Endpoints.login,
        data: {'phone': phone, 'password': password},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.register,
        data: {
          'phone': phone,
          'password': password,
          'displayName': displayName,
          'experienceYears': experienceYears,
          'address': address,
          'level': level,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> refreshAccessToken(String refreshToken) async {
    try {
      final response = await _dio.get(
        Endpoints.refresh(refreshToken),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
