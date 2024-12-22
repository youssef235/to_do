import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do/constants/routes.dart';
import '../cubit/todo_cubit.dart';
import '../models/todo_model.dart';
import '../widgets/AddTaskButton.dart';
import '../widgets/DatePickerWidget.dart';
import '../widgets/DropdownInputWidget.dart';
import '../widgets/ImagePickerWidget.dart';
import '../widgets/TextInputWidget.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String selectedPriority = 'medium';
  String selectedStatus = 'waiting';

  DateTime? selectedDate;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  File? _imageFile;

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    String? token = await _storage.read(key: 'accessToken');
    print("Token: $token");
    if (pickedFile != null && mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Add New Task',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImagePickerWidget(imageFile: _imageFile, onPickImage: () => _pickImage(context)),
              const SizedBox(height: 20),
              TextInputWidget(controller: titleController, label: 'Task title', hintText: 'Enter title here...'),
              const SizedBox(height: 20),
              TextInputWidget(controller: descriptionController, label: 'Task Description', hintText: 'Enter description here...', maxLines: 5),
              const SizedBox(height: 20),
              DropdownInputWidget(
                value: selectedPriority,
                items: [
                  {'text': 'High Priority', 'value': 'high', 'icon': Icons.flag_outlined},
                  {'text': 'Medium Priority', 'value': 'medium', 'icon': Icons.flag_outlined},
                  {'text': 'Low Priority', 'value': 'low', 'icon': Icons.flag_outlined},
                ],
                onChanged: (value) {
                  print("Priority selected: $value");
                  setState(() {
                    selectedPriority = value!;
                  });
                },
                label: 'Priority',
              ),
              const SizedBox(height: 20),
              DropdownInputWidget(
                value: selectedStatus,
                items: [
                  {'text': 'In Progress', 'value': 'inprogress', 'icon': Icons.hourglass_empty},
                  {'text': 'Waiting', 'value': 'waiting', 'icon': Icons.access_time},
                  {'text': 'Finished', 'value': 'finished', 'icon': Icons.check_circle},
                ],
                onChanged: (value) {
                  print("Status selected: $value");
                  setState(() {
                    selectedStatus = value!;
                  });
                },
                label: 'Status',
              ),

              const SizedBox(height: 20),
              const Text('Due date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              DatePickerWidget(selectedDate: selectedDate, onPickDate: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              }),
              const SizedBox(height: 30),
              AddTaskButton(onPressed: () async {
                String? token = await _storage.read(key: 'accessToken');
                if (token != null && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {

                  final newTask = TodoModel(
                    title: titleController.text,
                    desc: descriptionController.text,
                    priority: selectedPriority,
                    status: selectedStatus,
                    dueDate: selectedDate != null
                        ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                        : 'No date selected',
                    image: _imageFile?.path ?? "defaultImage",
                  );

                  if (_imageFile != null) {
                    try {
                      await context.read<TodoCubit>().uploadImage(_imageFile!, token);
                    } catch (e) {
                      print("Error uploading image: $e");
                    }
                  }

                  await context.read<TodoCubit>().addTask(newTask);
                  Navigator.pushNamed(context, AppRoutes.home);
                } else {
                  print("Missing token or fields");
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
