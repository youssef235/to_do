import 'dart:io';
import 'package:to_do/Featurees/qr/models/task_model.dart';
import 'package:to_do/Featurees/todos/models/todo_model.dart';
import 'package:to_do/Featurees/todos/repositories/todo_repository_interface.dart';
import 'package:to_do/core/network/endpoints.dart';
import '../services/api_todo_services.dart';

class TodoRepository implements TodoRepositoryInterface {
  final ApiTodoServices apiService;

  TodoRepository(this.apiService);

  @override
  Future<List<TodoModel>> getTasks() async {
    final response = await apiService.getTasks();
    return (response.data as List).map((e) => TodoModel.fromJson(e)).toList();
  }

  @override
  Future<void> addTask(TodoModel task) async {
    await apiService.addTask(task.toJson());
  }

  @override
  Future<String> uploadImage(File imageFile, String token) async {
    try {
      final result = await apiService.uploadImage(
        endpoint: Endpoints.uploadimage,
        file: imageFile,
        token: token,
      );
      print("Image upload successful: $result");
      return result['image'] as String;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> editTask(String taskId, {String? title, String? desc ,String? status,String? priority}) async {
    final Map<String, dynamic> data = {};
    if (title != null) data['title'] = title;
    if (desc != null) data['desc'] = desc;
    if (status != null) data['status'] = status;
    if (priority != null) data['priority'] = priority;

    await apiService.editTask(taskId, data: data);
  }

  Future<void> deleteTask(String taskId) async {
    await apiService.deleteTask(taskId);
  }

  Future<TodoModel> getTaskById(String taskId) async {
    final response = await apiService.getTaskById(taskId);
    return TodoModel.fromJson(response.data);
  }
}
