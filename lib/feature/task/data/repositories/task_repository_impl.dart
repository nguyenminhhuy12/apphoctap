import '../data/task_remote_datasource.dart';
import '../../domain/entities/task.dart';
import '../model/task_model.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final TaskRemoteDatasource remoteDatasource;

  TaskRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Task>> getTasks() async {
    List<TaskModel> listTask = await remoteDatasource.getAllTas();
    return listTask;
  }
  @override
  Future<Task> getTask(String id) async {
    TaskModel? taskModel = await remoteDatasource.getTasById(id);
    if(taskModel == null)
    {
      throw Exception('Task not found');
    }
    return taskModel;
  }
  @override
  Future<void> createTask(Task s) async {
    TaskModel bm = TaskModel.fromEntity(s);
    await remoteDatasource.addTas(bm);
  }
  @override
  Future<void> deleteTask(String id) async {
    await remoteDatasource.deleteTas(id);
  }
  @override
  Future<void> updateTask(Task s) async {
    await remoteDatasource.updateTas(TaskModel.fromEntity(s));
  }
}