import '../model/score_model.dart';
import 'package:apphoctap/core/data/firebase_remote_datasource.dart';

abstract class ScoreRemoteDatasource {
  Future<List<ScoreModel>> getAllStu();
  Future<ScoreModel?> getStuById(String id);
  Future<void> addstu(ScoreModel mu);
}

class ScoreRemoteDatasourceImpl implements ScoreRemoteDatasource{
  final FirebaseRemoteDatasource<ScoreModel> _remoteSource;

  ScoreRemoteDatasourceImpl()
  : _remoteSource = FirebaseRemoteDatasource<ScoreModel>(
      collectionName: 'scores',
      fromFirestore: (doc) => ScoreModel.fromFirestore(doc),
      toFirestore: (model) => model.toJson(),
  );
  @override
  Future<List<ScoreModel>> getAllStu() async {
    List<ScoreModel> listScore = [];
    listScore = await _remoteSource.getAll();
    return listScore;
  }
  @override
  Future<ScoreModel?> getStuById(String id) async {
    ScoreModel? stu = await _remoteSource.getById(id);
    return stu;
  }
  @override
  Future<void> addstu(ScoreModel score) async {
    await _remoteSource.add(score);
  }
}