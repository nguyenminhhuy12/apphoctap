import '../entities/course.dart';
import '../repositories/course_repository.dart';

class CreateCourse {
  final CourseRepository repo;
  CreateCourse(this.repo);

  Future<void> call(Course s) => repo.createCourse(s);
}