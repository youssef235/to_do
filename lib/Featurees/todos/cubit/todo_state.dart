import 'package:to_do/Featurees/qr/models/task_model.dart';

import '../models/todo_model.dart';

abstract class TodoState {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TodoState {}

class TaskLoading extends TodoState {
  final bool isInitialLoad;

  TaskLoading({this.isInitialLoad = false});

  @override
  List<Object> get props => [isInitialLoad];
}

class TaskLoaded extends TodoState {
  final List<TodoModel> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}

class TaskAdded extends TodoState {}

class TaskUpdated extends TodoState {
  final String taskId;

  final TodoModel updatedTask;


  TaskUpdated({required this.taskId, required this.updatedTask});

  @override
  List<Object> get props => [taskId];
}

class TaskDeleted extends TodoState {
  final String taskId;

  TaskDeleted({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class TaskError extends TodoState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}

class ImageUploadLoading extends TodoState {}

class ImageUploadSuccess extends TodoState {
  final String imagePath;

  ImageUploadSuccess(this.imagePath);
}

class ImageUploadError extends TodoState {
  final String error;

  ImageUploadError(this.error);
}
