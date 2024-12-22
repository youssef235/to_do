class Endpoints {
  static const String baseUrl = "https://todo.iraqsapp.com";

  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";

  static const String profile = "$baseUrl/auth/profile";

  static const String createtodo = "$baseUrl/todos";
  static const String uploadimage = "$baseUrl/upload/image";
  static const String getodos = "$baseUrl/todos?page=1";
  static  String editodo(String todoid) => "$baseUrl/todos/$todoid";
  static  String deltodo(String todoid) => "$baseUrl/todos/$todoid";
  static  String getodo(String todoid) => "$baseUrl/todos/$todoid";


  static String refresh(String refreshToken) =>
      "$baseUrl/auth/refresh-token?token=$refreshToken";
}
