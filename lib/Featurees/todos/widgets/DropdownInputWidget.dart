import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class DropdownInputWidget extends StatelessWidget {
  final String value;
  final List<Map<String, dynamic>> items; 
  final Function(String?) onChanged;
  final String label;

  const DropdownInputWidget({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Row(
                children: [
                  Icon(
                    item['icon'],
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item['text'], // النص الكامل الذي يظهر للمستخدم.
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.secondaryColor,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
          iconEnabledColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
