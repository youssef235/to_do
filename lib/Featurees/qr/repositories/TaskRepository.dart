import '../../todos/models/todo_model.dart';
import '../../todos/services/api_todo_services.dart';

class TaskRepository {
  final ApiTodoServices apiService;

  TaskRepository(this.apiService);

  Future<TodoModel> getTaskById(String taskId) async {
    try {
      final response = await apiService.getTaskById(taskId);
      return TodoModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }
}
