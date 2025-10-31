import '../data/course_remote_datasource.dart';
import '../../domain/entities/course.dart';
import '../model/course_model.dart';
import '../../domain/repositories/course_repository.dart';

class CourseRepositoryImpl extends CourseRepository {
  final CourseRemoteDatasource remoteDatasource;

  CourseRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Course>> getCourses() async {
    List<CourseModel> listCourse = await remoteDatasource.getAllCou();
    return listCourse;
  }
  @override
  Future<Course> getCourse(String id) async {
    CourseModel? courseModel = await remoteDatasource.getCouById(id);
    if(courseModel == null)
    {
      throw Exception('Course not found');
    }
    return courseModel;
  }
  @override
  Future<void> createCourse(Course s) async {
    CourseModel bm = CourseModel.fromEntity(s);
    await remoteDatasource.addCou(bm);
  }
  @override
  Future<void> deleteCourse(String id) async {
    await remoteDatasource.deleteCou(id);
  }
  @override
  Future<void> updateCourse(Course s) async {
    await remoteDatasource.updateCou(CourseModel.fromEntity(s));
  }
  
}