import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repo;
  CreateTask(this.repo);

  Future<void> call(Task s) => repo.createTask(s);
}