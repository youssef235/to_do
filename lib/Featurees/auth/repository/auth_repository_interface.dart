import '../models/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<UserModel> login(String phone, String password);
  Future<void> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> refreshAccessToken();
}
