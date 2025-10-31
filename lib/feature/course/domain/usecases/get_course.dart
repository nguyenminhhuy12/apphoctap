import '../entities/course.dart';
import '../repositories/course_repository.dart';

class GetCourse {
  final CourseRepository repo;
  GetCourse(this.repo);
  
  Future<Course> call(String id) => repo.getCourse(id);
}