import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:to_do/Featurees/todos/cubit/todo_state.dart';
import 'package:to_do/Featurees/todos/models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;
  String? uploadedImagePath;

  TodoCubit(this.repository) : super(TaskInitial());

  Future<void> getTasks() async {
    if (state is TaskLoading && (state as TaskLoading).isInitialLoad) {
      emit(TaskLoading(isInitialLoad: false));
    } else {
      emit(TaskLoading(isInitialLoad: true));
    }
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load Tasks $e'));
    }
  }

  Future<void> uploadImage(File imageFile, String token) async {
    emit(ImageUploadLoading());
    try {
      final imagePath = await repository.uploadImage(imageFile, token);
      uploadedImagePath = imagePath;
      emit(ImageUploadSuccess(imagePath));
    } catch (e) {
      emit(ImageUploadError('فشل في رفع الصورة: $e'));
    }
  }

  Future<void> addTask(TodoModel task) async {
    emit(TaskLoading());
    try {
      if (uploadedImagePath != null) {
        task = task.copyWith(image: uploadedImagePath);
      }
      await repository.addTask(task);
      uploadedImagePath = null;
      emit(TaskAdded());
      getTasks();
    } catch (e) {
      emit(TaskError('فشل في إضافة المهمة: $e'));
    }
  }


  Future<void> editTask(String taskId, {String? title, String? desc, String? status, String? priority}) async {
    try {
      emit(TaskLoading());
      await repository.editTask(taskId, title: title, desc: desc, status: status, priority: priority);

      final updatedTask = await repository.getTaskById(taskId);
      emit(TaskUpdated(taskId: taskId, updatedTask: updatedTask));
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      emit(TaskLoading());
      await repository.deleteTask(taskId);
      emit(TaskDeleted(taskId: taskId));
    } catch (e) {
      emit(TaskError('فشل في حذف المهمة: $e'));
    }
  }


}
