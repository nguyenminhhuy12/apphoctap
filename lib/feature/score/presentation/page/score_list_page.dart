import 'package:flutter/material.dart';

import '../../data/data/score_remote_datasource.dart';
import '../../domain/entities/score.dart';
import '../../data/repositories/score_repository_impl.dart';

import '../../domain/usecases/create_score.dart';
import '../../domain/usecases/get_all_score.dart';
import '../../domain/usecases/get_score.dart';

class ScoreListPage extends StatefulWidget {
  const ScoreListPage({super.key});

  @override
  State<ScoreListPage> createState() => ScoreListPageState();
}

class ScoreListPageState extends State<ScoreListPage> {  
  // Các lớp "UseCase" để tương tác với tầng Domain và Data

  // Tầng datasource – truy xuất dữ liệu Firestore
  late final _remote = ScoreRemoteDatasourceImpl();

  // Repository: đóng vai trò trung gian giữa datasource và usecase
  late final _repo = ScoreRepositoryImpl(_remote);

  // Các use case tương ứng với các hành động CRUD
  late final _getAllScores = GetAllScore(_repo);
 
  late final _getScoreById = GetScore(_repo);

  // Controller cho ô tìm kiếm
  final TextEditingController _searchCtrl = TextEditingController();

  // Biến lưu chuỗi tìm kiếm
  String _searchQuery = '';

  // Danh sách sinh viên được lọc theo từ khóa
  List<Score> _filteredScore = [];

  // Danh sách tất cả sinh viên lấy từ Firestore
  List<Score> _scores = [];

  // Hàm khởi tạo state ban đầu
  @override
  void initState() {
    super.initState();
    _initAuth();
  }


  Future<void> _initAuth() async {
    await _loadScores();
  }

  Future<void> _loadScores() async {
    final scores = await _getAllScores();
    setState(() {
      _scores = scores;
      _filteredScore = scores; 
    });
  }

  // 🔍 Tìm sinh viên theo ID (dùng khi muốn tìm bằng mã)
  Future<void> _searchScore() async {
    final id = _searchCtrl.text.trim();
    if (id.isEmpty) {
      // Nếu để trống, load lại tất cả sinh viên
      await _loadScores();
      return;
    }

    try {
      // Gọi usecase lấy sinh viên theo ID
      final score = await _getScoreById(id);
      setState(() => _scores = [score]);
    } catch (e) {
      // Nếu không tìm thấy, xóa danh sách và hiển thị thông báo
      setState(() => _scores = []);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy sinh viên!')),
      );
    }
  }
// void _sortByYear() {
//   setState(() {
//     _Scores.sort((a, b) => b.year.compareTo(a.year));
//     _filteredScore.sort((a, b) => b.year.compareTo(a.year));
//   });
// }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh AppBar phía trên
      appBar: AppBar(
        title: const Text('Score List'),
        actions: [
          // Nút refresh để tải lại dữ liệu
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadScores,
          ),
        ],

        // Phần dưới AppBar – ô tìm kiếm (PreferredSize cho phép thêm widget dưới AppBar)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo tên bài hát...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _filteredScore = _scores.where((s) {
                    return s.taskname.toLowerCase().contains(_searchQuery);
                  }).toList();
                 // _sortByYear();
                });
              },
            ),
          ),
        ),
      ),

      // Phần thân hiển thị danh sách sinh viên
      body: _filteredScore.isEmpty
          ? const Center(child: Text('No Scores found.'))
          : ListView.builder(
              itemCount: _filteredScore.length,
              itemBuilder: (context, index) {
                final c = _filteredScore[index];
                return ListTile(
                  // Avatar tròn có ký tự đầu của tên sinh viên
                  leading: CircleAvatar(
                    child: Text(c.taskname[0].toUpperCase()),
                  ),
                  // Hiển thị thông tin chính
                  title: Text(c.taskname),
                  subtitle: Text(
                    'Tên bài ktra: ${c.taskname}\ndiem so: ${c.score}\nso lan lam: ${c.times}',
                  ),
                  isThreeLine: true,
                  // Các nút chức năng bên phải (sửa / xóa)
                );
              },
            ),
    );
  }
}
