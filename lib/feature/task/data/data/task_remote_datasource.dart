import '../model/task_model.dart';
import 'package:apphoctap/core/data/firebase_remote_datasource.dart';

abstract class TaskRemoteDatasource {
  Future<List<TaskModel>> getAllTas();
  Future<TaskModel?> getTasById(String id);
  Future<void> addTas(TaskModel mu);
  Future<void> updateTas(TaskModel mu);
  Future<void> deleteTas(String id);
}

class TaskRemoteDatasourceImpl implements TaskRemoteDatasource {
  final FirebaseRemoteDatasource<TaskModel> _remoteSource;

  // Nhận collectionName từ bên ngoài
  TaskRemoteDatasourceImpl({required String collectionName})
      : _remoteSource = FirebaseRemoteDatasource<TaskModel>(
          collectionName: collectionName,
          fromFirestore: (doc) => TaskModel.fromFirestore(doc),
          toFirestore: (model) => model.toJson(),
        );

  @override
  Future<List<TaskModel>> getAllTas() async {
    return await _remoteSource.getAll();
  }

  @override
  Future<TaskModel?> getTasById(String id) async {
    return await _remoteSource.getById(id);
  }

  @override
  Future<void> addTas(TaskModel task) async {
    await _remoteSource.add(task);
  }

  @override
  Future<void> deleteTas(String id) async {
    await _remoteSource.delete(id);
  }

  @override
  Future<void> updateTas(TaskModel task) async {
    await _remoteSource.update(task.id, task);
  }
}
