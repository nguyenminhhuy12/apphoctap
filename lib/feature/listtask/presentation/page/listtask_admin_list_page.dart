import 'package:flutter/material.dart';
import 'package:apphoctap/feature/listtask/presentation/page/listtask_form_page.dart'; // 👈 import TaskFormPage
import 'package:apphoctap/feature/task/presentation/page/task_list_page.dart';

import '../../data/data/listtask_remote_datasource.dart';
import '../../data/repositories/listtask_repository_impl.dart';
import '../../domain/entities/listtask.dart';

import '../../domain/usecases/create_listtask.dart';
import '../../domain/usecases/delete_listtask.dart';
import '../../domain/usecases/update_listtask.dart';
import '../../domain/usecases/get_all_listtask.dart';
import '../../domain/usecases/get_listtask.dart';
import '../../domain/usecases/create_task_collection.dart';

// 👇 import thêm usecase cho tasks
import '../../../task/data/data/task_remote_datasource.dart';
import '../../../task/data/repositories/task_repository_impl.dart';

class ListtaskAdminListPage extends StatefulWidget {
  const ListtaskAdminListPage({super.key});

  @override
  State<ListtaskAdminListPage> createState() => _ListtaskAdminListPageState();
}

class _ListtaskAdminListPageState extends State<ListtaskAdminListPage> {
  late final _remote = ListtaskRemoteDatasourceImpl();
  late final _repo = ListtaskRepositoryImpl(_remote);

  late final _getAllListtasks = GetAllListtask(_repo);
  late final _addListtask = CreateListtask(_repo);
  late final _updateListtask = UpdateListtask(_repo);
  late final _deleteListtask = DeleteListtask(_repo);
  late final _getListtaskById = GetListtask(_repo);
  late final _createTaskCollection = CreateTaskCollection(_repo);

  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  List<Listtask> _listtasks = [];
  List<Listtask> _filteredListtasks = [];

  @override
  void initState() {
    super.initState();
    _loadListtasks();
  }

  Future<void> _loadListtasks() async {
    final listtasks = await _getAllListtasks();
    setState(() {
      _listtasks = listtasks;
      _filteredListtasks = listtasks;
    });
  }

  Future<void> _delete(String id) async {
    await _deleteListtask(id);
    await _loadListtasks();
  }

  Future<void> _openForm([Listtask? item]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListtaskFormPage(
          listtask: item,
          createUsecase: _addListtask,
          updateUsecase: _updateListtask,
          createCollectionUsecase: _createTaskCollection,
        ),
      ),
    );

    if (result == true) _loadListtasks();
  }

  /// 🆕 Khi bấm vào 1 Listtask, mở trang thêm/sửa câu hỏi (TaskFormPage)
  Future<void> _openTaskForm(Listtask listtask) async {
    print('📘 Mở form chỉnh sửa câu hỏi trong collection: ${listtask.taskname}');

    // tạo data source riêng cho task theo tên collection
    final taskRemote = TaskRemoteDatasourceImpl(collectionName: listtask.taskname);
    final taskRepo = TaskRepositoryImpl(taskRemote);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskListPageState(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Listtask'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadListtasks,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm theo tên bài kiểm tra...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _filteredListtasks = _listtasks.where((s) {
                    return s.name.toLowerCase().contains(_searchQuery);
                  }).toList();
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
      body: _filteredListtasks.isEmpty
          ? const Center(child: Text('Không có bài kiểm tra nào.'))
          : ListView.builder(
              itemCount: _filteredListtasks.length,
              itemBuilder: (context, index) {
                final item = _filteredListtasks[index];
                return ListTile(
                  onTap: () => _openTaskForm(item), // 👈 mở trang TaskFormPage
                  leading: CircleAvatar(
                    child: Text(item.name[0].toUpperCase()),
                  ),
                  title: Text(item.name),
                  subtitle: Text('Taskname: ${item.taskname} | Times: ${item.times}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _openForm(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(item.id.toString()),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
