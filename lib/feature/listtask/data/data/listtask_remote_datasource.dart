import '../model/listtask_model.dart';
import 'package:apphoctap/core/data/firebase_remote_datasource.dart';

abstract class ListtaskRemoteDatasource {
  Future<List<ListtaskModel>> getAlltea();
  Future<ListtaskModel?> getteaById(String id);
  Future<void> addtea(ListtaskModel customer);
  Future<void> updatetea(ListtaskModel customer);
  Future<void> deletetea(String id);
  Future<void> createcollection(String name);
}

class ListtaskRemoteDatasourceImpl implements ListtaskRemoteDatasource{
  final FirebaseRemoteDatasource<ListtaskModel> _remoteSource;

  ListtaskRemoteDatasourceImpl()
  : _remoteSource = FirebaseRemoteDatasource<ListtaskModel>(
      collectionName: 'listtask',
      fromFirestore: (doc) => ListtaskModel.fromFirestore(doc),
      toFirestore: (model) => model.toJson(),
  );
  @override
  Future<List<ListtaskModel>> getAlltea() async {
    List<ListtaskModel> listListtask = [];
    listListtask = await _remoteSource.getAll();
    return listListtask;
  }
  @override
  Future<ListtaskModel?> getteaById(String id) async {
    ListtaskModel? stu = await _remoteSource.getById(id);
    return stu;
  }
  @override
  Future<void> addtea(ListtaskModel Listtask) async {
    await _remoteSource.add(Listtask);
  }
  @override
  Future<void> deletetea(String id) async{
    await _remoteSource.delete(id);
  }
  @override
  Future<void> updatetea(ListtaskModel Listtask) async {
    await _remoteSource.update(Listtask.id, Listtask);
  }
  @override
  Future<void> createcollection(String name) async {
    await _remoteSource.createEmptyCollection(name);
  }
}