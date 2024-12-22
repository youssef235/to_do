import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do/Featurees/auth/services/api_auth_services.dart';
import '../models/user_model.dart';
import 'auth_repository_interface.dart';

final _storage = FlutterSecureStorage();

class AuthRepository implements AuthRepositoryInterface {
  final Dio _dio;
  final ApiAuthServices _apiAuthServices;

  AuthRepository(this._dio) : _apiAuthServices = ApiAuthServices(_dio);

  @override
  Future<UserModel> login(String phone, String password) async {
    try {
      final response = await _apiAuthServices.login(phone, password);
      final user = UserModel.fromJson(response.data);
      await _saveTokens(user.accessToken, user.refreshToken);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    try {
      final response = await _apiAuthServices.register(
        phone: phone,
        password: password,
        displayName: displayName,
        experienceYears: experienceYears,
        address: address,
        level: level,
      );
      if (response.statusCode != 200) {
        throw Exception('Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  @override
  Future<bool> refreshAccessToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      return false;
    }

    try {
      final response = await _apiAuthServices.refreshAccessToken(refreshToken);
      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await _storage.write(key: 'accessToken', value: newAccessToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }
}
