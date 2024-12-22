import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final Function() onPressed;

  const AddTaskButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5c34e3),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: onPressed,
        child: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
