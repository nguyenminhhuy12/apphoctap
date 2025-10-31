import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetAllCourse {
  final CourseRepository repo;
  GetAllCourse(this.repo);

  Future<List<Course>> call() => repo.getCourses();
}