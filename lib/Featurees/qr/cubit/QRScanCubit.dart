import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/TaskRepository.dart';
import 'QRScanState.dart';


class QRScanCubit extends Cubit<QRScanState> {
  final TaskRepository taskRepository;

  QRScanCubit(this.taskRepository) : super(QRScanInitial());

  Future<void> fetchTaskById(String taskId) async {
    emit(QRScanLoading());
    try {
      final task = await taskRepository.getTaskById(taskId);
      print('Fetched Task: ${task.toString()}');
      emit(QRScanSuccess(task));
    } catch (e) {
      print('Error while fetching task: $e');
      emit(QRScanError('Failed to fetch task. Please try again.'));
    }
  }

}
