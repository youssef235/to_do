import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../constants/colors.dart';
import '../../../constants/routes.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../qr/screens/QRScanScreen.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../widgets/TaskCard.dart';
import '../widgets/TaskFilterChips.dart';
import 'TodoDetailScreen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  String selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TodoCubit>(context).getTasks();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
        } else {
          if (!isLoadingMore) {
            setState(() {
              isLoadingMore = true;
            });
            BlocProvider.of<TodoCubit>(context).getTasks().then((_) {
              setState(() {
                isLoadingMore = false;
              });
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Logo',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.primaryColor),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              Navigator.pushNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(children: [Text("My Tasks" , style: TextStyle(fontWeight: FontWeight.bold , color: Colors.grey))],),
          ),
          TaskFilterChips(
            selectedFilter: selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                selectedFilter = filter;
              });
            },
          ),
          Expanded(
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<TodoCubit>(context).getTasks();
                  },
                  child: state is TaskLoading && !isLoadingMore
                      ? const Center(child: CircularProgressIndicator())
                      : state is TaskLoaded
                      ? _buildTaskList(state.tasks)
                      : state is TaskError
                      ? Center(child: Text(state.message))
                      : const Center(child: Text('No tasks available.')),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addtodo);
              },
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.add,
                size: screenWidth * 0.08,
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 0,
            child: InkWell(
              onTap: () async {
                final _storage = FlutterSecureStorage();
                final token = await _storage.read(key: 'accessToken');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScanScreen(token: token!),
                  ),
                );
              },
              child: CircleAvatar(
                radius: screenWidth * 0.08,
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                child: Icon(Icons.qr_code, color: Colors.purple, size: screenWidth * 0.07),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterTasks(List<dynamic> tasks) {
    if (selectedFilter == 'All') return tasks;
    return tasks
        .where((task) => task.status.toLowerCase() == selectedFilter.toLowerCase())
        .toList();
  }

  Widget _buildTaskList(List<dynamic> tasks) {
    final filteredTasks = _filterTasks(tasks);

    if (filteredTasks.isEmpty) {
      return const Center(child: Text('No tasks available.'));
    }

    return ListView.builder(
      itemCount: filteredTasks.length + (isLoadingMore ? 1 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) {
        if (index == filteredTasks.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final task = filteredTasks[index];
        return TaskCard(
          task: task,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsPage(task: task),
              ),
            );
          },
          backgroundColor: AppColors().getStatusBackgroundColor(task.status),
          textColor: AppColors().getStatusTextColor(task.status),
          priorityColor: AppColors().getStatuspriorityColor(task.priority), onDelete: (){
          context.read<TodoCubit>().deleteTask(task.id);
          Navigator.pushNamed(context, AppRoutes.home);

        },
        );
      },
    );
  }
}
