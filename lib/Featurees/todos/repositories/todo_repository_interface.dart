import 'dart:io';

import '../models/todo_model.dart';


abstract class TodoRepositoryInterface {
  Future<List<TodoModel>> getTasks();
  Future<void> addTask(TodoModel task);
  Future<String> uploadImage(File imageFile, String token);
}
