import 'package:flutter/material.dart';
import '../Featurees/auth/screens/login.dart';
import '../Featurees/auth/screens/signup.dart';
import '../Featurees/profile/Screens/profile_screen.dart';
import '../Featurees/splash/screens/onboarding_screen.dart';
import '../Featurees/splash/screens/splash_screen.dart';
import '../Featurees/todos/screens/AddTodoScreen.dart';
import '../Featurees/todos/screens/TodoListScreen.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String addtodo = '/addtodo';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case home:
        return MaterialPageRoute(builder: (_) => TodoListScreen());
      case addtodo:
        return MaterialPageRoute(builder: (_) => AddTodoScreen());
      default:
        return MaterialPageRoute(builder: (_) => TodoListScreen());
    }
  }
}
