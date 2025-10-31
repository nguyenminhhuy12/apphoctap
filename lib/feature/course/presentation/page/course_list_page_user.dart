import 'package:flutter/material.dart';
import 'package:apphoctap/feature/course/domain/entities/course.dart';
import 'package:apphoctap/feature/course/data/data/course_remote_datasource.dart';
import 'package:apphoctap/feature/course/data/repositories/course_repository_impl.dart';
import 'package:apphoctap/feature/course/domain/usecases/get_all_course.dart';
import 'course_study_page.dart';

class CourseListPageUser extends StatefulWidget {
  const CourseListPageUser({super.key});

  @override
  State<CourseListPageUser> createState() => _CourseListPageUserState();
}

class _CourseListPageUserState extends State<CourseListPageUser> {
  late final _remote = CourseRemoteDatasourceImpl();
  late final _repo = CourseRepositoryImpl(_remote);
  late final _getAllCourses = GetAllCourse(_repo);

  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _getAllCourses();
    setState(() {
      _courses = courses;
      _filteredCourses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học của bạn'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCourses),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Tìm khóa học...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                  _filteredCourses = _courses.where((c) {
                    return c.title.toLowerCase().contains(_searchQuery) ||
                        c.courseTitle.toLowerCase().contains(_searchQuery);
                  }).toList();
                });
              },
            ),
          ),
        ),
      ),
      body: _filteredCourses.isEmpty
          ? const Center(child: Text('Không có khóa học nào.'))
          : ListView.builder(
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final c = _filteredCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: c.thumbnail.isNotEmpty
                          ? AssetImage(c.thumbnail) as ImageProvider
                          : const AssetImage('assets/images/testimage1.png'),
                    ),
                    title: Text(
                      c.courseTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      c.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseStudyPage(course: c),
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
