import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTask {
  final TaskRepository repo;
  GetTask(this.repo);
  
  Future<Task> call(String id) => repo.getTask(id);
}