import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final Function() onPickDate;

  const DatePickerWidget({Key? key, this.selectedDate, required this.onPickDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(15),
          color: AppColors.secondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null
                  ? 'Choose due date...'
                  : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.black),
            ),
            Icon(Icons.calendar_today, color: AppColors.primaryColor), // تغيير لون الأيقونة
          ],
        ),
      ),
    );
  }
}
