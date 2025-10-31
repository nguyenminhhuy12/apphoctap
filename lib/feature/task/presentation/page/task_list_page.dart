import 'package:flutter/material.dart';
import 'package:apphoctap/feature/listtask/data/data/listtask_remote_datasource.dart';
import 'package:apphoctap/feature/listtask/data/repositories/listtask_repository_impl.dart';
import 'package:apphoctap/feature/task/domain/entities/task.dart';
import 'package:apphoctap/feature/task/domain/usecases/create_task.dart';
import 'package:apphoctap/feature/task/domain/usecases/delete_task.dart';
import 'package:apphoctap/feature/task/domain/usecases/get_all_task.dart';
import 'package:apphoctap/feature/task/domain/usecases/get_task.dart';
import 'package:apphoctap/feature/task/domain/usecases/update_task.dart';
import 'package:apphoctap/feature/task/presentation/page/task_form_page.dart';

import '../../data/data/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import 'package:apphoctap/feature/listtask/domain/entities/listtask.dart';
import 'package:apphoctap/feature/listtask/domain/usecases/get_all_listtask.dart';
import 'package:apphoctap/feature/listtask/domain/repositories/listtask_repository.dart';

class TaskListPageState extends StatefulWidget {
  const TaskListPageState({super.key});

  @override
  State<TaskListPageState> createState() => _TaskListPageStateState();
}

class _TaskListPageStateState extends State<TaskListPageState> {
  // UseCases
  late GetAllTask _getAllTask;
  late CreateTask _addTask;
  late UpdateTask _updateTask;
  late DeleteTask _deleteTask;
  late GetTask _getTaskById;

  // Datasource & Repository
  TaskRemoteDatasourceImpl? _remote;
  TaskRepositoryImpl? _repo;

  // Search
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // Data
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initDatasource();
  }

  Future<void> _initDatasource() async {
    try {
      // 1️⃣ Lấy danh sách collection từ UseCase GetAllListtask
      final listtaskDatasource = ListtaskRemoteDatasourceImpl();
      final listtaskRepo = ListtaskRepositoryImpl(listtaskDatasource);
      final getAllListtaskUC = GetAllListtask(listtaskRepo);
      final listtasks = await getAllListtaskUC();

      if (listtasks.isEmpty) {
        throw Exception('Không có collection nào trong listtask');
      }

      // 2️⃣ Lấy taskname đầu tiên làm collectionName
      final taskName = listtasks.first.taskname;

      // 3️⃣ Khởi tạo datasource & repository
      _remote = TaskRemoteDatasourceImpl(collectionName: taskName);
      _repo = TaskRepositoryImpl(_remote!);

      // 4️⃣ Khởi tạo UseCases CRUD
      _getAllTask = GetAllTask(_repo!);
      _addTask = CreateTask(_repo!);
      _updateTask = UpdateTask(_repo!);
      _deleteTask = DeleteTask(_repo!);
      _getTaskById = GetTask(_repo!);

      // 5️⃣ Load danh sách Task
      await _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi khởi tạo datasource: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTasks() async {
    
    final tasks = await _getAllTask();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  Future<void> _delete(String id) async {
    await _deleteTask(id);
    await _loadTasks();
  }

  Future<void> _openForm([Task? task]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(
          task: task,
          createUsecase: _addTask,
          updateUsecase: _updateTask,
        ),
      ),
    );

    if (result == true) _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTasks),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm theo câu hỏi...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _filteredTasks = _tasks
                      .where((t) => t.question.toLowerCase().contains(_searchQuery))
                      .toList();
                });
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: _filteredTasks.isEmpty
          ? const Center(child: Text('Không có Task nào.'))
          : ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final t = _filteredTasks[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(t.question),
                  subtitle: Text(
                      'A: ${t.a}\nB: ${t.b}\nC: ${t.c}\nD: ${t.d}\nAnswer: ${t.answer}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(t.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
