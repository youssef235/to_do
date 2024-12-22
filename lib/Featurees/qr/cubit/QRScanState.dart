

import '../../todos/models/todo_model.dart';
import '../models/task_model.dart';

abstract class QRScanState {}

class QRScanInitial extends QRScanState {}

class QRScanLoading extends QRScanState {}

class QRScanSuccess extends QRScanState {
  final TodoModel task;
  QRScanSuccess(this.task);
}

class QRScanError extends QRScanState {
  final String message;
  QRScanError(this.message);
}
