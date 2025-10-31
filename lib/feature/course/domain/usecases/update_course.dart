import '../entities/course.dart';
import '../repositories/course_repository.dart';

class UpdateCourse {
  final CourseRepository repo;
  UpdateCourse(this.repo);

  Future<void> call(Course t) => repo.updateCourse(t);
}