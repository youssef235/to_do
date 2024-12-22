import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:to_do/Featurees/auth/repository/auth_repository.dart';

import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> login(String phone, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(phone, password);
      emit(AuthSuccess("Login successful!"));
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 401) {
        final refreshed = await refreshAccessToken();
        if (refreshed) {
          await login(phone, password);
        } else {
          emit(AuthFailure("Login failed: ${e.toString()}"));
        }
      } else {
        emit(AuthFailure("Login failed: ${e.toString()}"));
      }
    }
  }


  Future<void> register({
    required String phone,
    required String password,
    required String displayName,
    required int experienceYears,
    required String address,
    required String level,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepository.register(
        phone: phone,
        password: password,
        displayName: displayName,
        experienceYears: experienceYears,
        address: address,
        level: level,
      );
      emit(AuthSuccess("Registration successful! Please login."));
    } catch (e) {
      emit(AuthFailure("Registration failed: ${e.toString()}"));
    }
  }


  Future<bool> refreshAccessToken() async {
    return await _authRepository.refreshAccessToken();
  }

  Future<String?> getAccessToken() async {
    return await _authRepository.getAccessToken();
  }

  Future<void> checkLoginStatus() async {
    final accessToken = await _authRepository.getAccessToken();
    if (accessToken != null) {
      emit(AuthSuccess("Logged in"));
    } else {
      emit(AuthFailure("Not logged in"));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthFailure("Logged out"));
  }
}
