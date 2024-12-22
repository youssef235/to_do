import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'Featurees/auth/cubit/auth_cubit.dart';
import 'Featurees/todos/cubit/todo_cubit.dart';
import 'Featurees/profile/Cubit/profile_cubit.dart';
import 'Featurees/qr/cubit/QRScanCubit.dart';
import 'app_setup.dart';
import 'constants/routes.dart';

void main() {
  final appSetup = AppSetup();
  runApp(MyApp(
    appSetup.authCubit,
    appSetup.todoCubit,
    appSetup.qrScanCubit,
    appSetup.profileCubit,
  ));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  final TodoCubit todoCubit;
  final QRScanCubit qrScanCubit;
  final ProfileCubit profileCubit;

  MyApp(this.authCubit, this.todoCubit, this.qrScanCubit, this.profileCubit);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => authCubit),
        BlocProvider(create: (context) => todoCubit),
        BlocProvider(create: (context) => qrScanCubit),
        BlocProvider(create: (context) => profileCubit),
      ],
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}