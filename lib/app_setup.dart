import 'package:dio/dio.dart';
import 'Featurees/auth/repository/auth_repository.dart';
import 'Featurees/todos/repositories/todo_repository.dart';
import 'Featurees/profile/repository/profile_repo.dart';
import 'Featurees/profile/services/api_services.dart';
import 'Featurees/qr/repositories/TaskRepository.dart';
import 'Featurees/todos/services/api_todo_services.dart';
import 'core/network/DioInterceptors.dart';
import 'Featurees/auth/cubit/auth_cubit.dart';
import 'Featurees/todos/cubit/todo_cubit.dart';
import 'Featurees/profile/Cubit/profile_cubit.dart';
import 'Featurees/qr/cubit/QRScanCubit.dart';

class AppSetup {
  late final Dio dio;
  late final AuthRepository authRepository;
  late final AuthCubit authCubit;
  late final ApiTodoServices apiService;
  late final ProfileApiServices profileApiServices;
  late final TodoRepository todoRepository;
  late final TaskRepository taskRepository;
  late final TodoCubit todoCubit;
  late final QRScanCubit qrScanCubit;
  late final ProfileRepo profileRepo;
  late final ProfileCubit profileCubit;

  AppSetup() {
    dio = Dio();
    authRepository = AuthRepository(dio);
    authCubit = AuthCubit(authRepository);
    DioInterceptors(dio, authCubit);
    apiService = ApiTodoServices(dio);
    profileApiServices = ProfileApiServices(dio);
    todoRepository = TodoRepository(apiService);
    taskRepository = TaskRepository(apiService);
    todoCubit = TodoCubit(todoRepository);
    qrScanCubit = QRScanCubit(taskRepository);
    profileRepo = ProfileRepo(profileApiServices);
    profileCubit = ProfileCubit(profileRepo);
  }
}