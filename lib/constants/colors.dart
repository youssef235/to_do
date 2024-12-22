import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF5D36E4);
  static const Color secondaryColor = Color(0xFFF4ECFC);


  static const Color textColor = Colors.black;
  static const Color subtitleColor = Colors.grey;

  static const Color backgroundColor = Colors.white;
  static const Color cardBackgroundColor = Color(0xFFF5F5F5);

  static const Color buttonColor = Color(0xFF5C34E3);
  static const Color buttonTextColor = Colors.white;

  Color getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.pink.shade50;
      case 'inprogress':
        return Colors.purple.shade50;
      case 'finished':
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade200;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.deepOrange;
      case 'inprogress':
        return Colors.deepPurple;
      case 'finished':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Color getStatuspriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.blue;
      case 'medium':
        return Colors.deepPurple;
      case 'high':
        return Colors.deepOrange;
      default:
        return Colors.black;
    }
  }
}
