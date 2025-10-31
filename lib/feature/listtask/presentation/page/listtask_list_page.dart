import 'package:flutter/material.dart';
import '../../data/data/listtask_remote_datasource.dart';
import '../../domain/entities/listtask.dart';
import '../../data/repositories/listtask_repository_impl.dart';

import '../../domain/usecases/create_listtask.dart';
import '../../domain/usecases/delete_listtask.dart';
import '../../domain/usecases/update_listtask.dart';
import '../../domain/usecases/get_all_listtask.dart';
import '../../domain/usecases/get_listtask.dart';

import 'package:apphoctap/feature/task/presentation/page/task_test_page.dart';
import 'package:apphoctap/feature/task/domain/entities/task.dart';

class ListtaskListPage extends StatefulWidget {
  const ListtaskListPage({super.key});

  @override
  State<ListtaskListPage> createState() => _ListtaskListPageState();
}

class _ListtaskListPageState extends State<ListtaskListPage> {  
  late final _remote = ListtaskRemoteDatasourceImpl();
  late final _repo = ListtaskRepositoryImpl(_remote);

  late final _getAllListtasks = GetAllListtask(_repo);
  // late final _addListtask = CreateListtask(_repo);
  // late final _updateListtask = UpdateListtask(_repo);
  // late final _deleteListtask = DeleteListtask(_repo);
  // late final _getListtaskById = GetListtask(_repo);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bài kiểm tra'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm Listtask...',
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
      body: _filteredListtasks.isEmpty
          ? const Center(child: Text('Không tìm thấy bài kiểm tra.'))
          : ListView.builder(
              itemCount: _filteredListtasks.length,
              itemBuilder: (context, index) {
                final listtask = _filteredListtasks[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(listtask.name[0].toUpperCase())),
                    title: Text(listtask.name),
                    subtitle: Text('Taskname: ${listtask.taskname},\nTimes${listtask.times}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Lấy taskname của listtask hiện tại
                      final collectionName = listtask.taskname;

                      // In ra console để kiểm tra
                      print('Selected collectionName: $collectionName');

                      // Điều hướng sang TaskListPageUser và truyền collectionName
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskTestPage(collectionName: collectionName,times: listtask.times),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
