import '../entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<Course> getCourse(String id);
  Future<void> createCourse(Course s);
  Future<void> updateCourse(Course s);
  Future<void> deleteCourse(String id);
  
}