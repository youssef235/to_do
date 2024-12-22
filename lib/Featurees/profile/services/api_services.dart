import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/profile_model.dart';
import '../../../core/network/endpoints.dart';

class ProfileApiServices {
  final Dio _dio;

  ProfileApiServices(this._dio);

  Future<ProfileModel> fetchProfile() async {

    try {
      const _storage = FlutterSecureStorage();

      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await _dio.get(
        Endpoints.profile,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}
