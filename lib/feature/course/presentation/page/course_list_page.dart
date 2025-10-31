import 'package:flutter/material.dart';
import 'package:apphoctap/feature/course/presentation/page/course_form_page.dart';

import '../../data/data/course_remote_datasource.dart';
import '../../domain/entities/course.dart';
import '../../data/repositories/course_repository_impl.dart';

import '../../domain/usecases/create_course.dart';
import '../../domain/usecases/delete_course.dart';
import '../../domain/usecases/update_course.dart';
import '../../domain/usecases/get_all_course.dart';
import '../../domain/usecases/get_course.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => CourseListPageState();
}

class CourseListPageState extends State<CourseListPage> {  
  // Các lớp "UseCase" để tương tác với tầng Domain và Data

  // Tầng datasource – truy xuất dữ liệu Firestore
  late final _remote = CourseRemoteDatasourceImpl();

  // Repository: đóng vai trò trung gian giữa datasource và usecase
  late final _repo = CourseRepositoryImpl(_remote);

  // Các use case tương ứng với các hành động CRUD
  late final _getAllCourses = GetAllCourse(_repo);
  late final _addCourse = CreateCourse(_repo);
  late final _updateCourse = UpdateCourse(_repo);
  late final _deleteCourse = DeleteCourse(_repo);
  late final _getCourseById = GetCourse(_repo);

  // Controller cho ô tìm kiếm
  final TextEditingController _searchCtrl = TextEditingController();

  // Biến lưu chuỗi tìm kiếm
  String _searchQuery = '';

  // Danh sách sinh viên được lọc theo từ khóa
  List<Course> _filteredCourse = [];

  // Danh sách tất cả sinh viên lấy từ Firestore
  List<Course> _courses = [];

  // Hàm khởi tạo state ban đầu
  @override
  void initState() {
    super.initState();
    _initAuth();
  }


  Future<void> _initAuth() async {
    await _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _getAllCourses();
    setState(() {
      _courses = courses;
      _filteredCourse = courses; 
    });
  }

  // Xóa sinh viên theo ID
  Future<void> _delete(String id) async {
    await _deleteCourse(id);
    await _loadCourses(); // Reload danh sách sau khi xóa
  }
  // Mở form thêm/sửa sinh viên
  Future<void> _openForm([Course? s]) async {
    print('du lieu tu list page:');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormPage(
          course: s,
          createUsecase: _addCourse,
          updateUsecase: _updateCourse,
        ),
      ),
    );

    // Nếu form trả về true (đã thêm/sửa thành công), load lại danh sách
    if (result == true) _loadCourses();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh AppBar phía trên
      appBar: AppBar(
        title: const Text('Course List'),
        actions: [
          // Nút refresh để tải lại dữ liệu
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
          ),
        ],

        // Phần dưới AppBar – ô tìm kiếm (PreferredSize cho phép thêm widget dưới AppBar)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm theo tên khóa học...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _filteredCourse = _courses.where((s) {
                    return s.title.toLowerCase().contains(_searchQuery);
                  }).toList();
                 // _sortByYear();
                });
              },
            ),
          ),
        ),
      ),

      // Nút thêm sinh viên (floating button)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),

      // Phần thân hiển thị danh sách sinh viên
      body: _filteredCourse.isEmpty
          ? const Center(child: Text('No Courses found.'))
          : ListView.builder(
              itemCount: _filteredCourse.length,
              itemBuilder: (context, index) {
                final c = _filteredCourse[index];
                return ListTile(
                  // Avatar tròn có ký tự đầu của tên sinh viên
                  leading: CircleAvatar(
                    child: Text(c.title[0].toUpperCase()),
                  ),
                  // Hiển thị thông tin chính
                  title: Text(c.title),
                  subtitle: Text(
                    'Tên bai hoc: ${c.title}\ncourse title: ${c.courseTitle}\nanh: ${c.thumbnail}\nurl: ${c.videoUrl}',
                  ),
                  isThreeLine: true,
                  // Các nút chức năng bên phải (sửa / xóa)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(c),
                        
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(c.id.toString()),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
