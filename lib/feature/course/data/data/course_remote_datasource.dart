import '../model/course_model.dart';
import 'package:apphoctap/core/data/firebase_remote_datasource.dart';

abstract class CourseRemoteDatasource {
  Future<List<CourseModel>> getAllCou();
  Future<CourseModel?> getCouById(String id);
  Future<void> addCou(CourseModel mu);
  Future<void> updateCou(CourseModel mu);
  Future<void> deleteCou(String id);
  
}

class CourseRemoteDatasourceImpl implements CourseRemoteDatasource{
  final FirebaseRemoteDatasource<CourseModel> _remoteSource;

  CourseRemoteDatasourceImpl()
  : _remoteSource = FirebaseRemoteDatasource<CourseModel>(
      collectionName: 'courses',
      fromFirestore: (doc) => CourseModel.fromFirestore(doc),
      toFirestore: (model) => model.toJson(),
  );
  @override
  Future<List<CourseModel>> getAllCou() async {
    List<CourseModel> listCourse = [];
    listCourse = await _remoteSource.getAll();
    return listCourse;
  }
  @override
  Future<CourseModel?> getCouById(String id) async {
    CourseModel? Cou = await _remoteSource.getById(id);
    return Cou;
  }
  @override
  Future<void> addCou(CourseModel c) async {
    await _remoteSource.add(c);
  }
  @override
  Future<void> deleteCou(String id) async{
    await _remoteSource.delete(id);
  }
  @override
  Future<void> updateCou(CourseModel b) async {
    await _remoteSource.update(b.id, b);
  }
 
  
}