import 'package:flutter/material.dart';
import 'package:apphoctap/feature/score/data/data/score_remote_datasource.dart';
import '../../data/data/task_remote_datasource.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_all_task.dart';
import 'package:apphoctap/feature/task/presentation/page/task_result_page.dart';
import 'package:apphoctap/feature/score/domain/usecases/create_score.dart';
import 'package:apphoctap/feature/score/domain/entities/score.dart';
import 'package:apphoctap/feature/score/data/repositories/score_repository_impl.dart';

class TaskTestPage extends StatefulWidget {
  final String collectionName; // 1️⃣ Nhận collectionName
  final int times;

  const TaskTestPage({super.key, required this.collectionName,required this.times});

  @override
  State<TaskTestPage> createState() => _TaskTestPageState();
}

class _TaskTestPageState extends State<TaskTestPage> {
  late final TaskRemoteDatasourceImpl _remote;
  late final TaskRepositoryImpl _repo;
  late final GetAllTask _getAllTasks;
  late final _remotescore = ScoreRemoteDatasourceImpl();
  late final _reposcore = ScoreRepositoryImpl(_remotescore);

  // Các use case tương ứng với các hành động CRUD
  late final _createScore = CreateScore(_reposcore);

  List<Task> _tasks = [];
  final Map<String, String> _userAnswers = {};
  double? _score;
  int? _correct;

  @override
  void initState() {
    super.initState();

    // 2️⃣ Khởi tạo datasource với collectionName từ widget
    _remote = TaskRemoteDatasourceImpl(collectionName: widget.collectionName);

    // 3️⃣ Repository & UseCase
    _repo = TaskRepositoryImpl(_remote);
    _getAllTasks = GetAllTask(_repo);

    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _submitQuiz() async {
  double score = 0.0;

  // Tính điểm (số câu đúng)
  for (final task in _tasks) {
    if (_userAnswers[task.id] == task.answer) {
      score++;
    }
  }

  // Tính tỷ lệ phần trăm và lấy 2 số sau dấu phẩy
  double percentage = (score / _tasks.length) * 100;
  String formattedPercentage = percentage.toStringAsFixed(2); // Lấy 2 số sau dấu phẩy

  // 1️⃣ Tạo Score entity với điểm % tính được
  final scoreEntity = Score(
    id: '', // Firestore sẽ tạo ID tự động nếu bạn muốn
    taskname: widget.collectionName, // collection hiện tại
    username: 'User', // Hoặc lấy từ auth nếu có
    score: double.parse(formattedPercentage), // Sử dụng điểm phần trăm đã định dạng
    times: widget.times,
  );

  // 2️⃣ Gọi UseCase CreateScore (dùng instance đã khai báo)
  try {
    await _createScore(scoreEntity);
    print('✅ Điểm đã được lưu vào Firestore');
  } catch (e) {
    print('❌ Lỗi khi lưu điểm: $e');
  }

  // 3️⃣ Điều hướng sang trang kết quả
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskResultPage(
        tasks: _tasks,
        userAnswers: _userAnswers,
        score: double.parse(formattedPercentage), // Chuyển điểm phần trăm sang trang kết quả
        times: widget.times,
      ),
    ),
  );
}

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...['a', 'b', 'c', 'd'].map((opt) {
              final text = {
                'a': task.a,
                'b': task.b,
                'c': task.c,
                'd': task.d,
              }[opt]!;

              return RadioListTile<String>(
                title: Text(text),
                value: opt,
                groupValue: _userAnswers[task.id],
                onChanged: (value) {
                  setState(() {
                    _userAnswers[task.id] = value!;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bài kiểm tra: ${widget.collectionName}')),
      body: _tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final task in _tasks) _buildTaskCard(task),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _userAnswers.length == _tasks.length
                      ? _submitQuiz
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Nộp bài',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
