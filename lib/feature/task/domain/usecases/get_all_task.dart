import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllTask {
  final TaskRepository repo;
  GetAllTask(this.repo);

  Future<List<Task>> call() => repo.getTasks();
}