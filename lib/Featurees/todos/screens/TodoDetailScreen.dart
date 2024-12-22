import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:to_do/Featurees/todos/cubit/todo_cubit.dart';
import 'package:to_do/Featurees/todos/models/todo_model.dart';
import 'package:to_do/constants/routes.dart';
import '../cubit/todo_state.dart';
import '../widgets/TextInputWidget.dart';
import '../widgets/DropdownInputWidget.dart';
import '../widgets/DatePickerWidget.dart';

class TaskDetailsPage extends StatefulWidget {
  final TodoModel task;

  const TaskDetailsPage({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TodoModel currentTask;
  bool isEditing = false;
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    currentTask = widget.task ;
    titleController = TextEditingController(text: currentTask.title);
    descController = TextEditingController(text: currentTask.desc);
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectedPriority = currentTask.priority ;
    String selectedStatus = currentTask.status ;
    DateTime? selectedDate;
    selectedDate = DateTime.parse(currentTask.dueDate);

    String qrData = '''
    ${currentTask.id}
    ''';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
        ),
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          isEditing
              ? IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<TodoCubit>().editTask(
                currentTask.id!,
                title: titleController.text,
                desc: descController.text,
                status: selectedStatus,
                priority: selectedPriority,
              );
              setState(() {
                isEditing = false;
              });
            },
          )
              : const SizedBox(),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                context.read<TodoCubit>().deleteTask(currentTask.id!);
                Navigator.pushNamed(context, AppRoutes.home);
              } else {
                setState(() {
                  isEditing = !isEditing;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit', style: TextStyle(color: Colors.black)),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ];
            },
          ),
        ],
      ),
      body: BlocListener<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is TaskUpdated && state.taskId == currentTask.id) {
            setState(() {
              currentTask = state.updatedTask;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: currentTask.image != "defaultImage"
                          ? (currentTask.image.startsWith('http')
                          ? Image.network(
                        currentTask.image,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(currentTask.image),
                        fit: BoxFit.cover,
                      ))
                          : const Image(
                        image: AssetImage('assets/images/test.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isEditing
                    ? TextInputWidget(
                  controller: titleController,
                  label: "Title",
                  hintText: "Enter task title",
                )
                    : Text(
                  currentTask.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                isEditing
                    ? TextInputWidget(
                  controller: descController,
                  label: "Description",
                  hintText: "Enter task description",
                  maxLines: 4,
                )
                    : Text(
                  currentTask.desc ,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Due Date",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                DatePickerWidget(
                  selectedDate: selectedDate,
                  onPickDate: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      context.read<TodoCubit>().editTask(
                        currentTask.id!,
                        title: titleController.text,
                        desc: descController.text,
                        status: selectedStatus,
                        priority: selectedPriority,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                DropdownInputWidget(
                  value: selectedPriority,
                  items: const [
                    {'text': 'High Priority', 'value': 'high', 'icon': Icons.flag},
                    {'text': 'Medium Priority', 'value': 'medium', 'icon': Icons.flag},
                    {'text': 'Low Priority', 'value': 'low', 'icon': Icons.flag},
                  ],
                  onChanged: (value) {
                    context.read<TodoCubit>().editTask(
                      currentTask.id!,
                      priority: value!,
                    );
                  },
                  label: 'Priority',
                ),
                const SizedBox(height: 20),
                DropdownInputWidget(
                  value: selectedStatus,
                  items: const [
                    {'text': 'In Progress', 'value': 'inprogress', 'icon': Icons.hourglass_empty},
                    {'text': 'Waiting', 'value': 'waiting', 'icon': Icons.access_time},
                    {'text': 'Finished', 'value': 'finished', 'icon': Icons.check_circle},
                  ],
                  onChanged: (value) {
                    context.read<TodoCubit>().editTask(
                      currentTask.id!,
                      status: value!,
                    );
                  },
                  label: 'Status',
                ),
                const SizedBox(height: 30),
                Center(
                  child: QrImageView(
                    data: qrData.trim(),
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
