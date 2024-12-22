import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:to_do/core/network/endpoints.dart';

const _storage = FlutterSecureStorage();

class ApiTodoServices {
  final Dio _dio;

  ApiTodoServices(this._dio);

  Future<Response> getTasks() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access Token is missing');
      }

      final response = await _dio.get(
        Endpoints.getodos,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> addTask(Map<String, dynamic> task) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access Token is missing');
      }

      Options options = Options(
        headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
      );

      final response = await _dio.post(
        Endpoints.createtodo,
        data: task,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> uploadImage({
    required String endpoint,
    required File file,
    required String token,
  }) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {'Authorization': 'Bearer $token'};

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(file.path),
      });

      Response response = await dio.post(endpoint, data: formData);

      if (response.statusCode == 200) {
        return jsonDecode(response.data);
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getTaskById(String taskId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access Token is missing');
      }

      taskId = taskId.replaceAll('"', '').trim();
      final url = Endpoints.getodo(taskId);

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTask(String taskId, {required Map<String, dynamic> data}) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access Token is missing');
      }

      final response = await _dio.put(
        Endpoints.editodo(taskId),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print("Task updated successfully");
        print(data);

      } else {
        print("Failed to update task");
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> deleteTask(String taskId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access Token is missing');
      }

      final response = await _dio.delete(
        Endpoints.deltodo(taskId),
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode == 200) {
        print("Task deleted successfully");
      } else {
        print("Failed to delete task");
      }
    } catch (e) {
      print("Error: $e");
    }
  }



}
